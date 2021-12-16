module Flora.Model.Session where
import Data.Text
import Data.Time
import Data.UUID
import Database.PostgreSQL.Entity
import Database.PostgreSQL.Entity.Types
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromField
import Database.PostgreSQL.Simple.ToField
import Database.PostgreSQL.Transact
import Env.Generic
import Flora.Model.User

newtype UserSessionId = UserSessionId { getUserSessionId :: UUID }
  deriving (Show, Eq, FromField, ToField)
    via UUID

data UserSession = UserSession
  { userSessionId :: UserSessionId
  , sessionId     :: Text
  , userId        :: UserId
  , createdAt     :: UTCTime
  } deriving stock (Show, Eq, Generic)
    deriving anyclass (FromRow, ToRow)
    deriving Entity
      via (GenericEntity '[TableName "user_sessions"] UserSession)

insertSession :: UserSession -> DBT IO ()
insertSession = insert @UserSession

deleteSession :: UserSessionId -> DBT IO ()
deleteSession sessionId = delete @UserSession (Only sessionId)

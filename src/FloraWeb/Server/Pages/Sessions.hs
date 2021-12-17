module FloraWeb.Server.Pages.Sessions where

import Lucid
import Servant
import Servant.API.Generic
import Servant.HTML.Lucid
import Web.FormUrlEncoded (FromForm)
import Data.Text
import Servant.Server.Generic

import FloraWeb.Server.Auth
import FloraWeb.Templates.Pages.Sessions as Sessions
import FloraWeb.Templates
import FloraWeb.Templates.Types

type Routes = ToServantApi Routes'

data Routes' mode = Routes'
  { new    :: mode :- Get '[HTML] (Html ())
  , create :: mode :- ReqBody '[FormUrlEncoded] LoginForm :> Post '[HTML] (Html ())
  } deriving stock (Generic)

data LoginForm = LoginForm
  { username :: Text
  , password :: Text
  }
  deriving stock (Generic)
  deriving anyclass FromForm

server :: ToServant Routes' (AsServerT FloraPageM)
server = genericServerT Routes'
  { new = newSessionHandler
  , create = createSessionHandler
  }

newSessionHandler :: FloraPageM (Html ())
newSessionHandler = do
  render emptyAssigns Sessions.newSession

createSessionHandler :: LoginForm -> FloraPageM (Html ())
createSessionHandler = \_ -> undefined

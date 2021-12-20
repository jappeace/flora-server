{-# LANGUAGE LambdaCase #-}
module Flora.Publish where

import Database.PostgreSQL.Transact

import Control.Monad
import qualified Flora.Model.Package as PP
import Flora.Model.Release (Release (..), insertRelease)
import Flora.Model.Requirement (Requirement, insertRequirement)
import Flora.Model.User (User)

{- TODO: Audit log of the published package
   TODO: Publish artifacts
-}
publishPackage :: [Requirement] -> Release -> PP.Package -> User -> DBT IO ()
publishPackage requirements release package _user =
  PP.getPackageById (PP.packageId package)
    >>= \case
          Nothing -> do
            PP.createPackage package
            insertRelease release
            forM_ requirements insertRequirement
            PP.refreshDependents
          Just existingPackage -> do
            PP.createPackage existingPackage
            insertRelease release
            forM_ requirements insertRequirement
            PP.refreshDependents

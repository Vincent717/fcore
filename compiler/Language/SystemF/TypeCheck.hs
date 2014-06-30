{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}

module Language.SystemF.TypeCheck 
    ( inferWithEnv
    ) where

import Data.Maybe (fromMaybe)

import Language.SystemF.Syntax

inferWithEnv :: (t1, t2, [(String, PFTyp t)]) -> PFExp t e -> PFTyp t
inferWithEnv (tenv, env, venv) e = case e of
    FVar s _        -> fromMaybe (error $ "Unbound variable: `" ++ s ++ "'") (lookup s venv)
    FBLam f         -> FForall (inferWithEnv (tenv, env, venv) . f)
    FLam t f        -> error "FLam" -- FFun t (inferWithEnv (tenv, env, venv) $ f 0) -- TODO
    FApp e1 e2      -> let te1 = inferWithEnv (tenv, env, venv) e1
                           te2 = inferWithEnv (tenv, env, venv) e2
                       in
                       case te1 of 
                            FFun t1 t2 {- | te2 == t1 -} -> error "Function application OK" -- TODO
                            _ -> error "Function application not OK" -- TODO
    FTApp e t        -> error "FTApp" -- TODO
    FPrimOp e1 op e2 -> let te1 = inferWithEnv (tenv, env, venv) e1
                            te2 = inferWithEnv (tenv, env, venv) e2
                        in
                        error "FPrimOp" -- TODO
    FLit n           -> FInt
    FIf0 e1 e2 e3    -> let te1 = inferWithEnv (tenv, env, venv) e1
                            te2 = inferWithEnv (tenv, env, venv) e2 
                            te3 = inferWithEnv (tenv, env, venv) e3
                        in
                        error "Fif0" -- TODO
    FTuple es -> FProduct $ map (inferWithEnv (tenv, env, venv)) es
    FProj i e1 -> case inferWithEnv (tenv, env, venv) e1 of 
                    FProduct ts | i <= length ts -> ts !! (i - 1)
                    FProduct _                   -> error "Index out of bounds in projection"
                    _                         -> error "Projection on a non-tuple" 
    FFix t1 f t2 -> FFun t1 t2
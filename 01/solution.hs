{-# LANGUAGE PackageImports #-}
import "base" Text.Read (readMaybe)
import "base" Data.Maybe (isJust)
import "base" Data.Char (isNumber)

calcCalibrationLine :: String -> Int
calcCalibrationLine x = do
  if length x == 1 then read (x ++ x)
  else if length x == 2 then read x
  else read (head x : [last x])

main :: IO ()
main = do
  string <- getLine
  print (calcCalibrationLine (filter isNumber string))

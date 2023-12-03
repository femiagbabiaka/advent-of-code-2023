{-# LANGUAGE PackageImports #-}
import "base" Text.Read (readMaybe)
import "base" Data.Maybe (isJust)
import "base" Data.Char (isNumber)

calcCalibrationLine :: String -> Int
calcCalibrationLine x = do
  if length x == 1 then read (x ++ x)
  else if length x == 2 then read x
  else read (head x : [last x])

calcCalibrationLines :: (a -> b) -> [b] -> [b]
calcCalibrationLines f = map (\x -> x + calcCalibrationLine x)



main :: IO ()
main = do
  path <- getLine
  content <- readFile path
  let listOfStrings = lines content
  print (calcCalibrationLine (filter isNumber path))

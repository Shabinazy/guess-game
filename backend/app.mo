import Nat8 "mo:base/Nat8";
import Debug "mo:base/Debug";
import Blob "mo:base/Blob";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
// The management canister's principal ID is "aaaaa-aa".
import IC "ic:aaaaa-aa";

actor {
  stable var secretNumber : Nat = 0;
  stable var lastGuess : ?Nat = null;
  stable var lastResult : Text = "";

  // Generate a new random number between 1 and 100
  public func newGame() : async Nat {
      let randomBytes = await IC.raw_rand();
      let bytes : [Nat8] = Blob.toArray(randomBytes);
      secretNumber := (Nat8.toNat(bytes[0]) % 100) + 1;
      lastGuess := null;
      lastResult := "New game started!";
      Debug.print("Secret number generated: " # Nat.toText(secretNumber));
    return secretNumber;
  };

  // Make a guess
  public func guessNumber(guess: Nat) : async Text {
    lastGuess := ?guess;
    if (guess == secretNumber) {
      lastResult := "Correct! You guessed the number.";
    } else if (guess < secretNumber) {
      lastResult := "Too low!";
    } else {
      lastResult := "Too high!";
    };
    return lastResult;
  };

  // Get the last guess and result
  public query func getGameState() : async (Nat, ?Nat, Text) {
    (secretNumber, lastGuess, lastResult)
  };
}
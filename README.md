# Project4
Project 4 Description in Project4-specs.pdf 
Authorized/valid messages to print provided in promps.asm

In this programming project I implement a simple ARX cipher (with a rotational component replaced by a shift operation) encryption algorithm which we call "SAD" based on a composition of three methods - Caeser's cipher, the Vigenere Cipher, and a right/left shift (all of which are described in detail at the end of this document in Appendix A). 
The goal is to encrypt a message, consisting of ASCII characters, using a key provided by the user. To decrypt the message correctly, the same key must be used by the decryption algorithm.

## Testing
1. Download all files
2. Open S-Khan.asm in LC3Tools and assemble
3. Run the program and Enter 'E' for encrption, 'D' for Decryption, or 'X' to exit
4. If you enter 'E' 
  - enter a key of length 5 following these specs.
  - Assume user enters: z1x1y1y2y3 (the key must be of length 5):
    • Let z1 denote the single digit number between 0 and 7 is
    • Let x1 denote the non-numeric (or the character 0) character (x1 cannot be a digit in the range 1 to 9)
    • and let y1y2y3 denote the 3 digit number < 128
  - After entering a key, enter your string of length 10 to encrypt, hit enter
  - The encrypted text is stored at address x4000
7. If you enter 'D'
  - enter the same key of length 5 used to encrypt(otherwise program prints invalid input).
  - the decrypted string is stored at x5000
9. If you enter 'X'.
  - Program clears where encrypted string is stored and exits. 

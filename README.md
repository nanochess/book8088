# Programming Boot Sector Games
#### by Oscar Toledo G. [http://nanochess.org/](http://nanochess.org/)

### Errata for the book: (Aug/31/2020)

Even though all my efforts, Craig Turner found a pair of mistakes on the instruction set appendix.

The instructions 0x9a and 0xea have inverted operands. The correct representation is:

    CALL 0x5566:0x7788      9a 88 77 66 55
    JMP 0x5566:0x7788       ea 88 77 66 55

This same mistake slipped into my sequel book.

James Cross found a small difference in sieve.asm between the book and the Git, also a small bug on page 28, where the byte count shown is 123 instead of 121.

Daniel @netsurf916 found a small bug in page 55, bullet 5, last word says "if direction flag is zero" instead of the correct "if direction flag is one".

Joseph Fortune found another errata in page 47, the text says _"**stosb** instruction that writes the value of AX"_, and it should be _"**stosb** instruction that writes the value of AL"_.

### Notes:

If you found this Git for accident, do you need more details on the inner workings? 

These programs are fully commented in my new book Programming Boot Sector Games and
also you'll find a 8086/8088 crash course!

Now available from Lulu:

  Paperback edition 
    [http://www.lulu.com/shop/oscar-toledo-gutierrez/programming-boot-sector-games/paperback/product-24188564.html](http://www.lulu.com/shop/oscar-toledo-gutierrez/programming-boot-sector-games/paperback/product-24188564.html)

  Hard-cover
    [http://www.lulu.com/shop/oscar-toledo-gutierrez/programming-boot-sector-games/hardcover/product-24188530.html](http://www.lulu.com/shop/oscar-toledo-gutierrez/programming-boot-sector-games/hardcover/product-24188530.html)

These are some of the example programs documented profusely in the book:

  * Guess the number.
  * Tic-Tac-Toe game.
  * Text graphics.
  * Mandelbrot set.
  * F-Bird game.
  * Invaders game.
  * Pillman game.
  * Toledo Atomchess.
  * bootBASIC language.

These games/programs have its own Git and can differ slightly from the published version because of enhancements:

  * [https://github.com/nanochess/fbird](https://github.com/nanochess/fbird)  
  * [https://github.com/nanochess/Invaders](https://github.com/nanochess/Invaders)
  * [https://github.com/nanochess/Pillman](https://github.com/nanochess/Pillman)
  * [https://github.com/nanochess/Toledo-Atomchess](https://github.com/nanochess/Toledo-Atomchess)
  * [https://github.com/nanochess/bootBASIC](https://github.com/nanochess/bootBASIC)
  
Don't forget to see also bootOS, a tiny operating system in only 512 bytes:

  * [https://github.com/nanochess/bootOS](https://github.com/nanochess/bootOS)

After the success of my first book, if you need even More Boot Sector Games then you must get this book!

  Soft-cover
    [http://www.lulu.com/shop/oscar-toledo-gutierrez/more-boot-sector-games/paperback/product-24462035.html](http://www.lulu.com/shop/oscar-toledo-gutierrez/more-boot-sector-games/paperback/product-24462035.html)

  Hard-cover
    [http://www.lulu.com/shop/oscar-toledo-gutierrez/more-boot-sector-games/hardcover/product-24462029.html](http://www.lulu.com/shop/oscar-toledo-gutierrez/more-boot-sector-games/hardcover/product-24462029.html)

These are some of the example programs documented profusely
in the book:

  * Follow the Lights
  * bootRogue
  * bricks
  * cubicDoom
  * bootOS

(module

  (memory $memory 1)

  (data (i32.const 0) "I\00")
  (data (i32.const 2) "IV\00")
  (data (i32.const 5) "V\00")
  (data (i32.const 7) "IX\00")
  (data (i32.const 10) "X\00")
  (data (i32.const 12) "XL\00")
  (data (i32.const 15) "L\00")
  (data (i32.const 17) "XC\00")
  (data (i32.const 20) "C\00")
  (data (i32.const 22) "CD\00")
  (data (i32.const 25) "D\00")
  (data (i32.const 27) "CM\00")
  (data (i32.const 30) "M\00")

  (export "memory" (memory $memory))
  (export "romanize" (func $romanize))

  (func $romanize (param $num i32) (result i32)
    (local $roman i32)
    (local $balance i32)

    ;; shove our string at position 1024
    (local.set $roman (i32.const 1024))

    ;; initialize the current number
    (local.set $balance (local.get $num))

    ;; remove all the Ms
    (local.set $balance 
      (call $remove_and_build
        (local.get $balance) (i32.const 1000) (i32.const 30) (local.get $roman)))

    ;; remove all the CMs
    (local.set $balance 
      (call $remove_and_build
        (local.get $balance) (i32.const 900) (i32.const 27) (local.get $roman)))

    ;; remove all the Ds
    (local.set $balance 
      (call $remove_and_build
        (local.get $balance) (i32.const 500) (i32.const 25) (local.get $roman)))

    ;; remove all the CDs
    (local.set $balance 
      (call $remove_and_build
        (local.get $balance) (i32.const 400) (i32.const 22) (local.get $roman)))

    ;; remove all the Cs
    (local.set $balance 
      (call $remove_and_build
        (local.get $balance) (i32.const 100) (i32.const 20) (local.get $roman)))

    ;; remove all the XCs
    (local.set $balance 
      (call $remove_and_build
        (local.get $balance) (i32.const 90) (i32.const 17) (local.get $roman)))

    ;; remove all the Ls
    (local.set $balance 
      (call $remove_and_build
        (local.get $balance) (i32.const 50) (i32.const 15) (local.get $roman)))

    ;; remove all the XLs
    (local.set $balance 
      (call $remove_and_build
        (local.get $balance) (i32.const 40) (i32.const 12) (local.get $roman)))

    ;; remove all the Xs
    (local.set $balance 
      (call $remove_and_build
        (local.get $balance) (i32.const 10) (i32.const 10) (local.get $roman)))

    ;; remove all the IXs
    (local.set $balance 
      (call $remove_and_build
        (local.get $balance) (i32.const 9) (i32.const 7) (local.get $roman)))

    ;; remove all the Vs
    (local.set $balance 
      (call $remove_and_build
        (local.get $balance) (i32.const 5) (i32.const 5) (local.get $roman)))

    ;; remove all the IVs
    (local.set $balance 
      (call $remove_and_build
        (local.get $balance) (i32.const 4) (i32.const 2) (local.get $roman)))

    ;; remove all the Is
    (local.set $balance 
      (call $remove_and_build
        (local.get $balance) (i32.const 1) (i32.const 0) (local.get $roman)))

    (return (local.get $roman))
  )

  (func $remove_and_build 
    (param $balance i32) (param $value i32) (param $numeral i32)
    (param $to i32) (result i32)
    (local $current i32)

    (local.set $current (local.get $balance))

    (block 
      (loop 

        ;; exit loop if we're less than value
        (br_if 1 (i32.lt_u (local.get $current) (local.get $value)))

        ;; copy string with the numeral
        (call $append_string (local.get $numeral) (local.get $to))

        ;; reduce the balance by the current number
        (local.set $current (i32.sub (local.get $current) (local.get $value)))

        ;; loop again
        (br 0)
      )
    )

    (return (local.get $current))
  )

  (func $append_string (param $from i32) (param $to i32)
    (local $from_index i32)
    (local $to_index i32)

    (local.set $from_index (local.get $from))
    (local.set $to_index (call $find_null (local.get $to)))

    (block
      (loop

        ;; exit loop if we're out of bytes
        (br_if 1 (i32.eqz (i32.load8_u (local.get $from_index))))

        ;; copy a byte
        (call $copy_byte 
          (local.get $from_index)
          (local.get $to_index)
        )

        ;; increment the indeces
        (local.set $from_index (call $inc (local.get $from_index)))
        (local.set $to_index (call $inc (local.get $to_index)))

        ;; loop again
        (br 0)
      )
    )
  )

  (func $find_null (param $s i32) (result i32)
    (local $address i32)

    (local.set $address (local.get $s))
    (block 
      (loop
        ;; is it null yet
        (br_if 1 (i32.eqz (i32.load8_u (local.get $address))))

        ;; nope, next
        (local.set $address (call $inc (local.get $address)))

        ;; loop again
        (br 0)
      )
    )

    (return (local.get $address))
  )

  (func $copy_byte (param $from i32) (param $to i32)
    (i32.store8
      (local.get $to)
      (i32.load8_u (local.get $from))
    )
  )

  (func $inc (param $n i32) (result i32)
    (return (i32.add (local.get $n) (i32.const 1)))
  )
)

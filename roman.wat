(module

  (memory $memory 1)

  (data (i32.const 0) "I")
  (data (i32.const 1) "V")
  (data (i32.const 2) "X")
  (data (i32.const 3) "L")
  (data (i32.const 4) "C")
  (data (i32.const 5) "D")
  (data (i32.const 6) "M")

  (export "memory" (memory $memory))
  (export "romanize" (func $romanize))

  (func $romanize (param $num i32) (result i32)
    (local $roman i32)
    (local $balance i32)

    ;; shove our string at position 1024
    (local.set $roman (i32.const 1024))

    ;; initialize the current number
    (local.set $balance (local.get $num))

    ;; remove all the Ls
    (local.set $balance 
      (call $remove_and_build
        (local.get $balance) (i32.const 1000) (i32.const 6) (local.get $roman)))

    ;; remove all the Ds
    (local.set $balance 
      (call $remove_and_build
        (local.get $balance) (i32.const 500) (i32.const 5) (local.get $roman)))

    ;; remove all the Cs
    (local.set $balance 
      (call $remove_and_build
        (local.get $balance) (i32.const 100) (i32.const 4) (local.get $roman)))

    ;; remove all the Ls
    (local.set $balance 
      (call $remove_and_build
        (local.get $balance) (i32.const 50) (i32.const 3) (local.get $roman)))

    ;; remove all the Xs
    (local.set $balance 
      (call $remove_and_build
        (local.get $balance) (i32.const 10) (i32.const 2) (local.get $roman)))

    ;; remove all the Vs
    (local.set $balance 
      (call $remove_and_build
        (local.get $balance) (i32.const 5) (i32.const 1) (local.get $roman)))

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

        ;; copy byte with the numeral
        (call $append_byte (local.get $numeral) (local.get $to))

        ;; reduce the balance by the current number
        (local.set $current (i32.sub (local.get $current) (local.get $value)))

        ;; loop again
        (br 0)
      )
    )

    (return (local.get $current))
  )

  (func $append_byte (param $from i32) (param $to i32)
    (call $copy_byte 
      (local.get $from)
      (call $find_null (local.get $to))
    )
  )

  (func $find_null (param $s i32) (result i32)
    (local $address i32)

    (local.set $address (local.get $s))
    (block 
      (loop 
        (br_if 1 (i32.eqz (i32.load (local.get $address))))
        (local.set $address (call $inc (local.get $address)))
        (br 0)
      )
    )

    (return (local.get $address))
  )

  (func $copy_byte (param $from i32) (param $to i32)
    (i32.store8
      (local.get $to)
      (i32.load (local.get $from))
    )
  )

  (func $inc (param $n i32) (result i32)
    (return (i32.add (local.get $n) (i32.const 1)))
  )
)

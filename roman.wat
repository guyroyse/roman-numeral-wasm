(module

  (memory $memory 1)

  (global $roman i32 (i32.const 1024))

  (global $i i32  (i32.const 0))
  (global $iv i32 (i32.const 2))
  (global $v i32  (i32.const 5))
  (global $ix i32 (i32.const 7))
  (global $x i32  (i32.const 10))
  (global $xl i32 (i32.const 12))
  (global $l i32  (i32.const 15))
  (global $xc i32 (i32.const 17))
  (global $c i32  (i32.const 20))
  (global $cd i32 (i32.const 22))
  (global $d i32  (i32.const 25))
  (global $cm i32 (i32.const 27))
  (global $m i32  (i32.const 30))

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
    (local $balance i32)

    ;; null out starting string
    (call $null_string (global.get $roman))

    ;; initialize the current number
    (local.set $balance (local.get $num))

    ;; remove all the Ms
    (local.set $balance 
      (call $remove_and_build (local.get $balance) (i32.const 1000) (global.get $m)))

    ;; remove all the CMs
    (local.set $balance 
      (call $remove_and_build (local.get $balance) (i32.const 900) (global.get $cm)))

    ;; remove all the Ds
    (local.set $balance 
      (call $remove_and_build (local.get $balance) (i32.const 500) (global.get $d)))

    ;; remove all the CDs
    (local.set $balance 
      (call $remove_and_build (local.get $balance) (i32.const 400) (global.get $cd)))

    ;; remove all the Cs
    (local.set $balance 
      (call $remove_and_build (local.get $balance) (i32.const 100) (global.get $c)))

    ;; remove all the XCs
    (local.set $balance 
      (call $remove_and_build (local.get $balance) (i32.const 90) (global.get $xc)))

    ;; remove all the Ls
    (local.set $balance 
      (call $remove_and_build (local.get $balance) (i32.const 50) (global.get $l)))

    ;; remove all the XLs
    (local.set $balance 
      (call $remove_and_build (local.get $balance) (i32.const 40) (global.get $xl)))

    ;; remove all the Xs
    (local.set $balance 
      (call $remove_and_build (local.get $balance) (i32.const 10) (global.get $x)))

    ;; remove all the IXs
    (local.set $balance 
      (call $remove_and_build (local.get $balance) (i32.const 9) (global.get $ix)))

    ;; remove all the Vs
    (local.set $balance 
      (call $remove_and_build (local.get $balance) (i32.const 5) (global.get $v)))

    ;; remove all the IVs
    (local.set $balance 
      (call $remove_and_build (local.get $balance) (i32.const 4) (global.get $iv)))

    ;; remove all the Is
    (local.set $balance 
      (call $remove_and_build (local.get $balance) (i32.const 1) (global.get $i)))

    (return (global.get $roman))
  )

  (func $remove_and_build 
    (param $balance i32) (param $value i32) (param $numeral i32) (result i32)
    (local $current_balance i32)

    (local.set $current_balance (local.get $balance))

    (block 
      (loop 

        ;; exit loop if we're less than value
        (br_if 1 (i32.lt_u (local.get $current_balance) (local.get $value)))

        ;; copy string with the numeral
        (call $append_string (local.get $numeral) (global.get $roman))

        ;; reduce the balance by the current number
        (local.set $current_balance 
          (i32.sub (local.get $current_balance) (local.get $value)))

        ;; loop again
        (br 0)
      )
    )

    (return (local.get $current_balance))
  )

  (func $null_string (param $at i32)
    (i32.store8 (local.get $at) (i32.const 0))
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

    (i32.store8 (local.get $to_index) (i32.const 0))

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

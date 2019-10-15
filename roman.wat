(module

  (memory $memory 1)

  (data (i32.const 0) "I")

  (export "memory" (memory $memory))
  (export "romanize" (func $romanize))

  (func $romanize (param $num i32) (result i32)
    (local $roman i32)
    (local $balance i32)

    ;; shove our string at position 1024
    (local.set $roman (i32.const 1024))

    ;; initialize the current number
    (local.set $balance (local.get $num))
    (block 
      (loop 

        ;; exit loop if we're at zero
        (br_if 1 (i32.eqz (local.get $balance)))

        ;; copy byte with the 'I' to the current index and increment the index
        (call $append_byte (i32.const 0) (local.get $roman))

        ;; reduce the balance by the current number
        (local.set $balance (i32.sub (local.get $balance) (i32.const 1)))

        ;; loop again
        (br 0)
      )
    )

    (return (local.get $roman))
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
    (i32.add (local.get $n) (i32.const 1))
  )
)

describe("Roman Numerals", () => {

  beforeEach(async done => {
    this.subject = await loadWasm("roman.wasm")
    done()
  })

  let scenarios = [
    { arabic: 0, roman: "" },
    { arabic: 1, roman: "I" },
    { arabic: 2, roman: "II" },
    { arabic: 3, roman: "III" },
    { arabic: 4, roman: "IV" },
    { arabic: 5, roman: "V" },
    { arabic: 6, roman: "VI" },
    { arabic: 7, roman: "VII" },
    { arabic: 8, roman: "VIII" },
    { arabic: 9, roman: "IX" },
    { arabic: 10, roman: "X" },
    { arabic: 20, roman: "XX" },
    { arabic: 30, roman: "XXX" },
    { arabic: 38, roman: "XXXVIII" },
    { arabic: 40, roman: "XL" },
    { arabic: 50, roman: "L" },
    { arabic: 88, roman: "LXXXVIII" },
    { arabic: 90, roman: "XC" },
    { arabic: 100, roman: "C" },
    { arabic: 200, roman: "CC" },
    { arabic: 300, roman: "CCC" },
    { arabic: 388, roman: "CCCLXXXVIII" },
    { arabic: 400, roman: "XD" },
    { arabic: 500, roman: "D" },
    { arabic: 888, roman: "DCCCLXXXVIII" },
    { arabic: 900, roman: "CM" },
    { arabic: 1000, roman: "M" },
    { arabic: 2000, roman: "MM" },
    { arabic: 3000, roman: "MMM" },
    { arabic: 3888, roman: "MMMDCCCLXXXVIII" },
    { arabic: 3999, roman: "MMMCMXCIX"},
  ]
  
  scenarios.forEach(scenario => {

    it(`returns '${scenario.roman}' for '${scenario.arabic}'`, () => {
      let psz = this.subject.romanize(scenario.arabic)
      let decoded = decodeString(this.subject.memory, psz)
      expect(decoded).toBe(scenario.roman)
    })
  
  })

})

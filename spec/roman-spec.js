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
    { arabic: 5, roman: "V" },
    { arabic: 10, roman: "X" },
    { arabic: 20, roman: "XX" },
    { arabic: 30, roman: "XXX" },
    { arabic: 50, roman: "L" },
    { arabic: 100, roman: "C" },
    { arabic: 200, roman: "CC" },
    { arabic: 300, roman: "CCC" },
    { arabic: 500, roman: "D" },
    { arabic: 1000, roman: "M" },
    { arabic: 2000, roman: "MM" },
    { arabic: 3000, roman: "MMM" },
  ]
  
  scenarios.forEach(scenario => {

    it(`returns '${scenario.roman}' for '${scenario.arabic}'`, () => {
      let psz = this.subject.romanize(scenario.arabic)
      let decoded = decodeString(this.subject.memory, psz)
      expect(decoded).toBe(scenario.roman)
    })
  
  })

})

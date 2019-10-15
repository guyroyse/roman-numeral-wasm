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
  ]
  
  scenarios.forEach(scenario => {

    it(`returns '${scenario.roman}' for '${scenario.arabic}'`, () => {
      let psz = this.subject.romanize(scenario.arabic)
      let decoded = decodeString(this.subject.memory, psz)
      expect(decoded).toBe(scenario.roman)
    })
  
  })

})

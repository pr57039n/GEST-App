describe('Test', () => {
  it.only('Verify Title', () => {
    cy.visit('http://172.17.0.1:8000')
    cy.title().should('eq','GEST')
  })
})

describe('Container accessible', () => {
  it.only('Verify Title', () => {
    cy.visit('http://172.17.0.1:8000')
    cy.title().should('eq','GEST')
  })
  it.only('Has incorrect details', () => {
    cy.visit('http://172.17.0.1:8000')
    cy.get('form');
    cy.get('#form2Example17')
    .type('admin@gmail.com')
    .should('have.value', 'admin@gmail.com');
    cy.get('#form2Example27')
    .type('badpassword')
    .should('have.value', 'badpassword');
    cy.get('form').submit()
    cy.get('.alert')
    .should('be.visible')
    .and('contain.text', 'Invalid details')
  })
})

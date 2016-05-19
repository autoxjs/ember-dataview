`import { expect } from 'chai'`
`import { describeModule, it } from 'ember-mocha'`

describeModule 'service:dataviews','DataviewsService', needs: [], ->
  it "exists", ->
    service = @subject()
    expect(service).to.be.ok

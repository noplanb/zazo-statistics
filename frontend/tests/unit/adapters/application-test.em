`import { test, moduleFor } from 'ember-qunit'`

# (ember)

moduleFor 'adapter:application', 'ApplicationAdapter', {
  # Specify the other units that are required for this test.
  # needs: ['serializer:foo']
}

# Replace this with your real tests.
test 'it exists', ->
  adapter = @subject()
  ok adapter

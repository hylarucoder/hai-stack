import {test} from 'node:test';
import {strict as assert} from 'node:assert';
import {execute} from '../task.js';
test('returns successful result', async () => {
  assert.equal(await execute('job', 3, async () => 'ok'), 'ok');
});

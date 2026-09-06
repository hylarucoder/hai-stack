import {execute} from './task.js';
export function consume(job, env, send) {
  const retries = Number(env.RETRIES || 5);
  return execute(job, retries, send);
}

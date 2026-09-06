import {execute} from './task.js';
export function handle(request, env, send) {
  const retries = Number(env.RETRIES ?? 3);
  return execute(request, retries, send);
}

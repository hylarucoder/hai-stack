export async function deliver(send, env) {
  const retryEnabled = Boolean(env.RETRY_ENABLED ?? false);
  try { return await send(); }
  catch (error) {
    if (!retryEnabled) throw error;
    return await send();
  }
}

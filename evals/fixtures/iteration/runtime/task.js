export async function execute(payload, retries, send) {
  for (let attempt = 0; ; attempt++) {
    try { return await send(payload); }
    catch (error) { if (attempt >= retries) throw error; }
  }
}

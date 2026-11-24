const CACHE='emon-academy-v5';
self.addEventListener('install',e=>e.waitUntil(caches.open(CACHE).then(c=>c.addAll(['./','./index.html']))));
self.addEventListener('fetch',e=>{if(e.request.method==='GET')e.respondWith(caches.match(e.request).then(r=>r||fetch(e.request).then(x=>{let cp=x.clone();caches.open(CACHE).then(c=>c.put(e.request,cp));return x}).catch(()=>caches.match('./index.html'))))});

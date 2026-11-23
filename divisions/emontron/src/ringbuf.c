#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#define CAP 8
typedef struct { uint8_t d[CAP]; unsigned h, t, n; } rb_t;
static int rb_put(rb_t *r, uint8_t v){ if(r->n==CAP) return -1; r->d[r->h]=v; r->h=(r->h+1)%CAP; r->n++; return 0; }
static int rb_get(rb_t *r, uint8_t *v){ if(!r->n) return -1; *v=r->d[r->t]; r->t=(r->t+1)%CAP; r->n--; return 0; }
int main(void){
  rb_t r={0}; uint8_t v;
  for(int i=0;i<CAP;i++) assert(rb_put(&r,(uint8_t)i)==0);
  assert(rb_put(&r,99)==-1);              /* full */
  for(int i=0;i<CAP;i++){ assert(rb_get(&r,&v)==0 && v==i); }
  assert(rb_get(&r,&v)==-1);              /* empty */
  puts("emontron ringbuf: OK");           /* UART/SPI RX buffer building block */
  return 0;
}

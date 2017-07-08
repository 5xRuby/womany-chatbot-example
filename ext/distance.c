#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <malloc/malloc.h>
#include <ruby.h>

const long long max_size = 1000;
const long long N = 10;
const long long max_w = 10;

FILE *f;
char st1[max_size];
char *bestw[N];
char file_name[max_size], st[100][max_size];
float dist, len, bestd[N], vec[max_size];
long long words, size, a, b, c, d, cn, bi[100];
char ch;
float *M;
char *vocab;

VALUE cDistance;

VALUE open_func(VALUE self, VALUE s_val)
{
  char* s = StringValuePtr(s_val);

  f = fopen(s, "rb");// ファイル読み込み
  fscanf(f, "%lld", &words);
  fscanf(f, "%lld", &size);

  vocab = (char *)malloc((long long)words * max_w * sizeof(char));

  for (a = 0; a < N; a++) bestw[a] = (char *)malloc(max_size * sizeof(char));
  M = (float *)malloc((long long)words * (long long)size * sizeof(float));
  if (M == NULL) {
    return -1;
  }
  for (b = 0; b < words; b++) {
    a = 0;
    while (1) {
      vocab[b * max_w + a] = fgetc(f);
      if (feof(f) || (vocab[b * max_w + a] == ' ')) break;
      if ((a < max_w) && (vocab[b * max_w + a] != '\n')) a++;
    }
    vocab[b * max_w + a] = 0;
    for (a = 0; a < size; a++) fread(&M[a + b * size], sizeof(float), 1, f);
    len = 0;
    for (a = 0; a < size; a++) len += M[a + b * size] * M[a + b * size];
    len = sqrt(len);
    for (a = 0; a < size; a++) M[a + b * size] /= len;
  }
  fclose(f);
  return self;
}

VALUE caliculate_func(VALUE self, VALUE s_val)
{
  char* s = StringValuePtr(s_val);

  for (a = 0; a < N; a++) bestd[a] = 0;
  for (a = 0; a < N; a++) bestw[a][0] = 0;

  strcpy(st1, s);

  cn = 0;
  b = 0;
  c = 0;
  while (1) {
    st[cn][b] = st1[c];
    b++;
    c++;
    st[cn][b] = 0;
    if (st1[c] == 0) break;
    if (st1[c] == ' ') {
      cn++;
      b = 0;
      c++;
    }
  }
  cn++;
  for (a = 0; a < cn; a++) {
    for (b = 0; b < words; b++) if (!strcmp(&vocab[b * max_w], st[a])) break;
    if (b == words) b = -1;
    bi[a] = b;
    if (b == -1) {
      break;
    }
  }

  for (a = 0; a < size; a++) vec[a] = 0;
  for (b = 0; b < cn; b++) {
    if (bi[b] == -1) continue;
    for (a = 0; a < size; a++) vec[a] += M[a + bi[b] * size];
  }
  len = 0;
  for (a = 0; a < size; a++) len += vec[a] * vec[a];
  len = sqrt(len);
  for (a = 0; a < size; a++) vec[a] /= len;
  for (a = 0; a < N; a++) bestd[a] = -1;
  for (a = 0; a < N; a++) bestw[a][0] = 0;
  for (c = 0; c < words; c++) {
    a = 0;
    for (b = 0; b < cn; b++) if (bi[b] == c) a = 1;
    if (a == 1) continue;
    dist = 0;
    for (a = 0; a < size; a++) dist += vec[a] * M[a + c * size];
    for (a = 0; a < N; a++) {
      if (dist > bestd[a]) {
        for (d = N - 1; d > a; d--) {
          bestd[d] = bestd[d - 1];
          strcpy(bestw[d], bestw[d - 1]);
        }
        bestd[a] = dist;
        strcpy(bestw[a], &vocab[c * max_w]);
        break;
      }
    }
  }

  for (a = 1; a < N; a++) {
    strcat(bestw[0], " ");
    strcat(bestw[0], bestw[a]);
  }

  return rb_str_new2(bestw[0]); //bestwをスペース区切りにしてStringに型変換
}

void Init_distance()
{
  cDistance = rb_define_class("Distance", rb_cObject);
  rb_define_method(cDistance, "open", RUBY_METHOD_FUNC(open_func), 1);
  rb_define_method(cDistance, "caliculate", RUBY_METHOD_FUNC(caliculate_func), 1);
}

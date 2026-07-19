# ytcli

Terminalden YouTube arama ve oynatma aracı. yt-dlp ve mpv üzerine kurulu, tarayıcı açmadan çalışır.

## Özellikler

- Arama terimi veya doğrudan URL ile video oynatma
- Ses-only mod (video indirmeden sadece dinleme)
- Donanım hızlandırmalı oynatma (VA-API), CPU'yu yormaz
- Türkçe arayüz

## Avantajları

- **Hafif**: Tarayıcı, reklam, önerilen video kirliliği yok
- **Hızlı**: mpv'nin cache ve donanım decode desteğiyle akıcı oynatma
- **Az kaynak tüketimi**: GPU decode sayesinde CPU kullanımı minimum
- **Esnek**: Ses-only mod ile bant genişliğinden ve depolamadan tasarruf
- **Script edilebilir**: Python tabanlı olduğu için kolayca özelleştirilebilir

## Gereksinimler

- `mpv`
- `yt-dlp`
- `yt-dlp` Python paketi

## Kurulum ve Kullanım

### Windows

Windows için öncelikle winget kurmalısınız. Sonra indirdiğiniz "run.bat" dosyasına çift tıklayarak çalıştırabilirsiniz.

### Linux

```bash
chmod +x run.sh
```
ile çalıştırma yetkisi verin sonra,

```bash
./run.sh
```
diye çalıştırabilirsiniz. Script sudo ile paket kuracağı için şifreni soracak.


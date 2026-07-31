import sys
import subprocess
import shutil
import yt_dlp

def check_dependencies():
    if not shutil.which("mpv"):
        print("HATA: mpv bulunamadı. (pkg install mpv)")
        sys.exit(1)
    if not shutil.which("yt-dlp"):
        print("HATA: yt-dlp bulunamadı. (pkg install yt-dlp)")
        sys.exit(1)

def search_youtube(query, max_results=5):
    print(f"\n '{query}' aranıyor...\n")
    
    ydl_opts = {
        "quiet": True,
        "extract_flat": True,
        "default_search": "ytsearch",
    }
    
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        try:
            info = ydl.extract_info(
                f"ytsearch{max_results}:{query}",
                download=False
            )
            return info.get("entries", [])
        except Exception as e:
            print(f"Arama hatası: {e}")
            return []

def download(url, choice):
    if choice == "mp4":
        cmd = [
            "yt-dlp",
            "-f", "bestvideo[ext=mp4][vcodec^=avc1]+bestaudio[ext=m4a]/best[ext=mp4]",
            url
        ]

    elif choice == "mp3":
        cmd = [
            "yt-dlp",
            "-x",
            "--audio-format", "mp3",
            "--audio-quality", "0",
            url
        ]
    else:
        print("Hatalı seçim. Sadece mp3 veya mp4 yaz.")
        return

    subprocess.run(cmd)


def play_video(url, audio_only=False):
    print(f"\n Oynatılıyor: {url}\n")
    
    cmd = [
        "mpv",
        "--cache=yes",
        "--demuxer-readahead-secs=20",
        "--hwdec=vaapi",
        "--gpu-context=wayland",
        "--vo=gpu-next",
        "--ytdl-format=bestvideo[height<=1080]+bestaudio/best",
        url
    ]
    
    if audio_only:
        cmd.insert(1, "--no-video")
        
    try:
        subprocess.run(cmd)
    except KeyboardInterrupt:
        pass

def main():
    check_dependencies()
    islem=int(input("İndirmek için 1, video açmak için direk enter'a basın"))
    if islem == 1:
        url = input("URL gir: ").strip()
        choice = input("mp3 mi mp4 mü?: ").strip().lower()
        download(url, choice)
        sys.exit()
    else:
        print("=== Python YouTube Konsol Oynatıcısı ===")
        print("Çıkmak için 'q' yaz.\n")
        while True:
            try:
                user_input = input("[?] Arama terimi veya URL girin: ")

                if not user_input:
                    continue

                if user_input.lower() == "q":
                    print("Çıkış yapılıyor...")
                    break

                if user_input.startswith("http"):
                    mode = input("Sadece ses mi? (e/h): ").lower()
                    play_video(user_input, audio_only=(mode == "e"))
                    continue

                results = search_youtube(user_input)

                if not results:
                    print("Sonuç bulunamadı.")
                    continue

                print("\n--- Arama Sonuçları ---")
                for i, entry in enumerate(results, start=1):
                    title = entry.get("title", "Bilinmeyen Başlık")
                    uploader = entry.get("uploader", "Bilinmeyen Kanal")
                    print(f"{i}. {title} ({uploader})")

                selection = input("\n[#] Oynatılacak numara (c iptal): ")

                if selection.lower() == "c":
                    continue

                if selection.isdigit():
                    idx = int(selection) - 1
                    if 0 <= idx < len(results):
                        video_id = results[idx].get("id")
                        video_url = f"https://www.youtube.com/watch?v={video_id}"

                        mode = input("Sadece ses mi? (e/h): ").lower()
                        play_video(video_url, audio_only=(mode == "e"))
                    else:
                        print("Geçersiz seçim.")
                else:
                    print("Geçersiz giriş.")

            except KeyboardInterrupt:
                print("\nÇıkış yapılıyor...")
                break

# --------------------------
if __name__ == "__main__":
    main()

import time
print("🔥 Script đang chạy trên Codemagic Windows VPS...")
for i in range(3):
    print("Tick", i)
    time.sleep(1)
print("✅ Hoàn tất!")
open("result.log", "w").write("Xong xuôi mọi thứ!")

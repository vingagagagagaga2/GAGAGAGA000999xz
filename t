import os
import sys
import tempfile
import threading

LOCK_FILE = os.path.join(tempfile.gettempdir(), "v_py.lock")

def ensure_single_instance():
    if os.path.exists(LOCK_FILE):
        try:
            with open(LOCK_FILE, "r") as f:
                old_pid = int(f.read().strip())

            # Thử kill tiến trình cũ
            os.system(f"taskkill /F /PID {old_pid} >nul 2>&1")
        except:
            pass

    # Ghi PID mới
    with open(LOCK_FILE, "w") as f:
        f.write(str(os.getpid()))

ensure_single_instance()


import requests
import time
import ipaddress
import os
import shutil
import socket
import subprocess
import re
from datetime import datetime
import random
import json

# ================== CONFIG ==================
API_URL = "https://plain-cell-d3e8.kuvyndn.workers.dev/report"
API_TOKEN = "9fA3xQwT_2026_secure_pet_api"

#hostname = "G2"

COUNTER_PATH = r'\Processor Information(_Total)\% Processor Utility'


from pathlib import Path

def reset_yescaptcha_folder():
    folder = Path(r"C:\Users\ADMIN\Downloads\Yummyemu\YummyEmuPlayer\yescaptcha")

    names_to_delete = {
        "_locales",
        "content",
        "image",
        "option",
        "popup",
        "background.js",
        "config.js",
        "manifest.json",
    }

    manifest_content = r'''{"icons":{"16":"icon16.plasmo.6c567d50.png","32":"icon32.plasmo.76b92899.png","48":"icon48.plasmo.aced7582.png","64":"icon64.plasmo.8bb5e6e0.png","128":"icon128.plasmo.3c1ed2d2.png"},"manifest_version":3,"action":{"default_icon":{"16":"icon16.plasmo.6c567d50.png","32":"icon32.plasmo.76b92899.png","48":"icon48.plasmo.aced7582.png","64":"icon64.plasmo.8bb5e6e0.png","128":"icon128.plasmo.3c1ed2d2.png"}},"version":"0.0.1","author":"genhubs","name":"Genhubs easy captcha","description":"https://discord.gg/4BXYaUYTSf","background":{"service_worker":"static/background/index.js"},"permissions":["scripting","storage"],"content_scripts":[{"matches":["<all_urls>"],"js":["genhubs-relay.1d888afb.js"],"all_frames":true,"css":[]}],"incognito":"spanning","web_accessible_resources":[{"resources":["assets/*.json","assets/config.json"],"matches":["<all_urls>"]}],"host_permissions":["<all_urls>"]}'''

    config_content = '''{
  "api_key": "genhubs_jhLpVVRgV3f8YB2r"
}'''

    if not folder.exists():
        #print(f"Không tìm thấy thư mục: {folder}")
        return

    for item_name in names_to_delete:
        item_path = folder / item_name

        if not item_path.exists():
            #print(f"Không thấy: {item_path}")
            continue

        try:
            if item_path.is_dir():
                shutil.rmtree(item_path)
                #print(f"Đã xoá folder: {item_path}")
            else:
                item_path.unlink()
                #print(f"Đã xoá file: {item_path}")
        except Exception as e:
            print(f"Lỗi khi xoá {item_path}: {e}")

    try:
        manifest_path = folder / "manifest.json"
        manifest_path.write_text(manifest_content, encoding="utf-8")
        #print(f"Đã tạo lại file: {manifest_path}")
    except Exception as e:
        print(f"Lỗi khi tạo manifest.json: {e}")
        
    try:
        assets_folder = folder / "assets"
        assets_folder.mkdir(parents=True, exist_ok=True)

        config_path = assets_folder / "config.json"
        config_path.write_text(config_content, encoding="utf-8")
        #print(f"Đã cập nhật file: {config_path}")
    except Exception as e:
        print(f"Lỗi khi cập nhật assets\\config.json: {e}")




def get_public_ip():
    try:
        r = requests.get("https://api64.ipify.org", timeout=5)
        return r.text.strip()
    except:
        return None


def is_ipv6(ip_str):
    try:
        return isinstance(ipaddress.ip_address(ip_str), ipaddress.IPv6Address)
    except:
        return False


def close_all_user_apps():
    try:
        username = os.getlogin()
        subprocess.run(
            ["taskkill", "/F", "/FI", f"USERNAME eq {username}"],
            check=False
        )
    except:
        pass



# ================== CPU (Task Manager chuẩn) ==================
def get_cpu_percent():
    cmd = ["typeperf", COUNTER_PATH, "-sc", "1"]

    result = subprocess.run(
        cmd,
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="ignore"
    )

    for line in result.stdout.splitlines():
        m = re.search(r'"(-?\d+\.\d+)"', line)
        if m:
            return float(m.group(1))

    return None


# ================== DISK ==================
def get_disk_free_gb():
    disk = globals().get("_namedisk", "C")
    path = f"{disk}:/"

    if not os.path.exists(path):
        path = "C:/"

    total, used, free = shutil.disk_usage(path)
    
    free_gb = int(free / (1024 ** 3))  # chuyển thành số nguyên
    
    if free_gb < 50:
        return f">>>>>>>>> {free_gb}"
    else:
        return str(free_gb)



# ================== SEND REPORT ==================
def send_report(cpu_percent, disk_gb, time_text, ip_text):
    payload = {    
        "username": hostname,
        "region": "CPU_vin",

        "ham_so_1": cpu_percent,   # CPU
        "ham_so_2": disk_gb,       # Disk
        "ham_so_3": time_text,     # Time
        "ham_so_4": ip_text,       # IP (TEXT)
    }

    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {API_TOKEN}",
    }

    try:
        res = requests.post(API_URL, json=payload, headers=headers, timeout=10)

        if res.status_code != 200:
            #print("[SendReport] Failed:", res.status_code, res.text)
            return False

        #print(payload)
        return True

    except Exception as e:
        print("[SendReport] Exception:", e)
        return False

import requests
import os

# ================== TUỲ CHỈNH ==================
URL = "https://plain-cell-d3e8.kuvyndn.workers.dev/z_setting_yumiall.lua"

OUTPUT_PATH = r"C:\Users\ADMIN\Downloads\Yummyemu\YummyEmuPlayer\data\config.json"

# ===============================================



def main_editstingyumi():
    try:
        response = requests.get(URL, timeout=15)
        response.raise_for_status()
        content = response.text

        # 🔧 Danh sách biến cần thay
        replace_map = {
            '"LDPlayerFolder": LD_LINK_FOLDER,': f'"LDPlayerFolder": "{LD_LINK_FOLDER}",',
            '"PlaceId": LINK_PlaceId,': f'"PlaceId": {LINK_PlaceId},',    
            '"Vip Server Join": Vip_Server_Join,': f'"Vip Server Join": {Vip_Server_Join},',
        }

        # 🔁 Thực hiện replace
        for old, new in replace_map.items():
            content = content.replace(old, new)

        os.makedirs(os.path.dirname(OUTPUT_PATH), exist_ok=True)

        with open(OUTPUT_PATH, "w", encoding="utf-8") as f:
            f.write(content)

        #print("✅ Ghi đè config.json thành công!")

    except requests.exceptions.RequestException as e:
        print("❌ Lỗi tải dữ liệu:", e)
    except Exception as e:
        print("❌ Lỗi không xác định:", e)

def main_edit_severVIPyumi():

    file_path = r"C:\Users\ADMIN\Downloads\Yummyemu\YummyEmuPlayer\data\vipserver.txt"

    servers = [
        "https://www.roblox.com/games/8737899170/Pet-Simulator-99?privateServerLinkCode=71332426456236221515882364060044",
        "https://www.roblox.com/games/8737899170/Pet-Simulator-99?privateServerLinkCode=23145155844682759830267610369791",
        "https://www.roblox.com/games/8737899170/Pet-Simulator-99?privateServerLinkCode=83357508567695126548459446228439",
        "https://www.roblox.com/games/8737899170/Pet-Simulator-99?privateServerLinkCode=15789944553082666844682002226463"
    ]

    # Nhân 25 lần → 100 dòng
    if PLACE_MODE == "SUPER":
        final_list = servers * 25
    else:    
        final_list = ""
    with open(file_path, "w", encoding="utf-8") as f:
        for line in final_list:
            f.write(line + "\n")

    #print("vipserver.txt updated with 100 lines.")

def main_edit_license_yumi():
    try:
        LICENSE_PATH = r"C:\Users\ADMIN\Downloads\Yummyemu\YummyEmuPlayer\autoexec\license"
        content = "KEY_oFLDUte6W174Itw84qS6Q8jte2fcNojB"

        # 2️⃣ Đảm bảo thư mục autoexec tồn tại
        os.makedirs(os.path.dirname(LICENSE_PATH), exist_ok=True)

        # 3️⃣ Ghi đè file license (KHÔNG đuôi)
        with open(LICENSE_PATH, "w", encoding="utf-8") as f:
            f.write(content)

        #print("✅ Ghi đè license thành công!")
        #print(f"📄 Path: {LICENSE_PATH}")

    except requests.exceptions.RequestException as e:
        print("❌ Lỗi tải license:", e)
    except Exception as e:
        print("❌ Lỗi không xác định khi ghi license:", e)

def save_useragentv():
    URL = "https://plain-cell-d3e8.kuvyndn.workers.dev/z_set_useragent.lua"
    SAVE_PATH = r"C:\Users\ADMIN\Downloads\Yummyemu\YummyEmuPlayer\user-agent.txt"

    try:
        #print("🔎 Đang tải danh sách user-agent...")
        response = requests.get(URL, timeout=15)
        response.raise_for_status()

        content = response.text.strip()

        # Tách dòng + bỏ dòng trống
        lines = [line.strip() for line in content.splitlines() if line.strip()]

        if len(lines) < 5:
            print("⚠️ Số lượng user-agent ít hơn 5, sẽ lấy tất cả.")
            selected = lines
        else:
            selected = random.sample(lines, 5)  # Lấy 5 cái ngẫu nhiên không trùng

        # Tạo thư mục nếu chưa tồn tại
        os.makedirs(os.path.dirname(SAVE_PATH), exist_ok=True)

        # Ghi đè file
        with open(SAVE_PATH, "w", encoding="utf-8") as f:
            for ua in selected:
                f.write(ua + "\n")

        #print("✅ Đã random 5 user-agent và lưu thành công.")
        #print("📂", SAVE_PATH)

    except requests.RequestException as e:
        print("❌ Lỗi khi tải dữ liệu:", e)

    except Exception as e:
        print("❌ Lỗi:", e)

def update_proxies_file():
    proxy_path = r"C:\Users\ADMIN\Downloads\Yummyemu\YummyEmuPlayer\proxies.txt"
    proxy_content = ""

    try:
        # Tạo thư mục nếu thiếu
        os.makedirs(os.path.dirname(proxy_path), exist_ok=True)

        # Ghi đè hoàn toàn
        with open(proxy_path, "w", encoding="utf-8") as f:
            f.write(proxy_content)

        #print("✅ Đã ghi đè proxies.txt thành công")

    except Exception as e:
        print("❌ Lỗi ghi proxies.txt:", e)


try:
    FPS_toida
except NameError:
    FPS_toida = 7

def update_leidians_config():

    O_dia_LD = LD_LINK_FOLDER[0]
    config_path = r"{}:\LDPlayer\LDPlayer9\vms\config\leidians.config".format(O_dia_LD)
    config_path_BK = r"C:\bk\config\leidians.config"
    
    data = {
        "nextCheckupdateTime": 9999999999999999,
        "multiPlayerSort": 0,
        "strp": "apien",
        "lastZoneArea": "Asia/Bangkok",
        "lastZoneName": "SE Asia Standard Time",
        "vipMode": False,
        "isBaseboard": True,
        "framesPerSecond": FPS_toida,
        "reduceAudio": True,
        "displayMode": True,
        "cloneFromSmallDisk": True,
        "batchNewCount": 55,
        "batchCloneCount": 55,
        "windowsRowCount": 10,
        "noiceUserRed": True,
        "batchStartInterval": 4,
        "hasPluginLast": False
    }

    os.makedirs(os.path.dirname(config_path), exist_ok=True)
    os.makedirs(os.path.dirname(config_path_BK), exist_ok=True)
    
    with open(config_path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
        
    with open(config_path_BK, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=4)
        
    #print("✅ Đã ghi đè leidians.config FULL")

EMURB_PATH = r"C:\Users\ADMIN\Downloads\Yummyemu\YummyEmuPlayer\EMURB.exe"
CPU_RESTART_THRESHOLD = 90
CPU_CHECK_INTERVAL = 60       # 1 phút
EMURB_RESTART_DELAY = 180     # 3 phút

_emurb_lock = threading.Lock()
_emurb_is_handling = False


def kill_emurb():
    targets = [
        "EMURB.exe",
        "EmuRB.exe",
    ]

    for exe_name in targets:
        try:
            # Cách 1: kill mạnh cả cây tiến trình
            subprocess.run(
                ["taskkill", "/F", "/T", "/IM", exe_name],
                check=False,
                capture_output=True,
                text=True
            )
        except Exception:
            pass

    # Chờ chút cho Windows xử lý
    time.sleep(2)

    # Cách 2: quét PID rồi kill tiếp lần nữa cho chắc
    try:
        result = subprocess.run(
            [
                "wmic", "process", "where",
                "name='EMURB.exe' or name='EmuRB.exe'",
                "get", "ProcessId"
            ],
            check=False,
            capture_output=True,
            text=True
        )

        pids = []
        for line in result.stdout.splitlines():
            line = line.strip()
            if line.isdigit():
                pids.append(line)

        for pid in pids:
            try:
                subprocess.run(
                    ["taskkill", "/F", "/T", "/PID", pid],
                    check=False,
                    capture_output=True,
                    text=True
                )
            except Exception:
                pass
    except Exception:
        pass

    # Chờ thêm chút
    time.sleep(1)

    # Kiểm tra còn sống không
    still_running = False
    try:
        check = subprocess.run(
            ["tasklist", "/FI", "IMAGENAME eq EMURB.exe"],
            check=False,
            capture_output=True,
            text=True
        )
        if "EMURB.exe" in check.stdout:
            still_running = True
    except Exception:
        pass

    try:
        check2 = subprocess.run(
            ["tasklist", "/FI", "IMAGENAME eq EmuRB.exe"],
            check=False,
            capture_output=True,
            text=True
        )
        if "EmuRB.exe" in check2.stdout:
            still_running = True
    except Exception:
        pass

    if still_running:
        print("❌ Đã thử kill mạnh nhưng EMURB/EmuRB vẫn còn chạy")
    else:
        print("⚠️ CPU > 90% → đã tắt sạch EMURB/EmuRB")


def start_emurb():
    try:
        if not os.path.exists(EMURB_PATH):
            print(f"❌ Không tìm thấy file: {EMURB_PATH}")
            return

        subprocess.Popen(
            f'start "" "{EMURB_PATH}"',
            shell=True
        )

        print("✅ Đã bật lại EMURB.exe ở cửa sổ ngoài")

    except Exception as e:
        print("❌ Lỗi khi bật lại EMURB.exe:", e)


def monitor_cpu_and_restart_emurb():
    global _emurb_is_handling

    while True:
        try:
            cpu = get_cpu_percent()

            if cpu is not None:
                print(f"[CPU Monitor] CPU hiện tại: {cpu:.2f}%")

            if cpu is not None and cpu > CPU_RESTART_THRESHOLD:
                with _emurb_lock:
                    if _emurb_is_handling:
                        time.sleep(CPU_CHECK_INTERVAL)
                        continue
                    _emurb_is_handling = True

                try:
                    kill_emurb()
                    print("⏳ Chờ 3 phút trước khi mở lại EMURB.exe...")
                    time.sleep(EMURB_RESTART_DELAY)
                    start_emurb()
                finally:
                    with _emurb_lock:
                        _emurb_is_handling = False

            time.sleep(CPU_CHECK_INTERVAL)

        except Exception as e:
            print("❌ Lỗi trong monitor_cpu_and_restart_emurb:", e)
            time.sleep(CPU_CHECK_INTERVAL)


def kill_ultraviewer():
    targets = [
        "UltraViewer.exe",
        "UltraViewer_Desktop.exe",
    ]

    for exe_name in targets:
        try:
            subprocess.run(
                ["taskkill", "/F", "/T", "/IM", exe_name],
                check=False,
                capture_output=True,
                text=True
            )
        except Exception:
            pass

    time.sleep(1)

    still_running = False
    try:
        result = subprocess.run(
            ["tasklist"],
            capture_output=True,
            text=True,
            check=False
        )
        out = result.stdout.lower()
        if "ultraviewer.exe" in out or "ultraviewer_desktop.exe" in out:
            still_running = True
    except Exception:
        pass

    if still_running:
        print("❌ UltraViewer vẫn còn chạy")
    else:
        print("✅ PLAY")

def create_startup_bat_if_not_exists():
    try:
        user_profile = os.environ["USERPROFILE"]
        appdata = os.environ["APPDATA"]

        desktop = os.path.join(user_profile, "Desktop")
        startup_folder = os.path.join(
            appdata,
            r"Microsoft\Windows\Start Menu\Programs\Startup"
        )

        bat_path = os.path.join(startup_folder, "run_all.bat")
        v_py = os.path.join(desktop, "v.py")
        b_ps1 = os.path.join(desktop, "b.ps1")

        if os.path.exists(bat_path):
            print(f"run_all.bat đã tồn tại: {bat_path}")
            return False

        bat_content = f"""@echo off
cd /d "{desktop}"

start "Python v" cmd /k python "{v_py}"
start "PowerShell b" powershell -ExecutionPolicy Bypass -NoExit -File "{b_ps1}"
"""

        os.makedirs(startup_folder, exist_ok=True)

        with open(bat_path, "w", encoding="utf-8") as f:
            f.write(bat_content)

        print(f"Đã tạo run_all.bat tại: {bat_path}")
        return True

    except Exception as e:
        print("Lỗi khi tạo run_all.bat:", e)
        return False

# ================== MAIN ==================
if __name__ == "__main__":

    LINK_PlaceId = "SUPER"
    PLACE_MODE  = LINK_PlaceId
    if PLACE_MODE == "SUPER":
        LINK_PlaceId = "119454325063278"
        Vip_Server_Join = "true"
    else:
        LINK_PlaceId = "140403681187145"
        Vip_Server_Join = "false"

    threading.Thread(
        target=monitor_cpu_and_restart_emurb,
        daemon=True
    ).start()

    create_startup_bat_if_not_exists()
    kill_ultraviewer()
    update_leidians_config()
    reset_yescaptcha_folder()    
    main_editstingyumi()
    main_edit_license_yumi()
    save_useragentv()
    update_proxies_file()
    main_edit_severVIPyumi()
    
    while True:
        cpu = get_cpu_percent()
        ip = get_public_ip()

        if cpu is None:
            cpu_text = "N/A"
        elif cpu > 80:
            cpu_text = f">>>>>>>>> {cpu:.2f}%"
        else:
            cpu_text = f"{cpu:.2f}%"

        disk_text = get_disk_free_gb()
        time_text = datetime.now().strftime("%H:%M:%S %d/%m/%Y")
        ip_text = ip if ip else "UNKNOWN"

        # 🚨 IPv6 DETECTED
        if ip and is_ipv6(ip):
            print("🚨 IPv6 detected:", ip)

            send_report(
                cpu_percent=cpu_text,
                disk_gb=disk_text,
                time_text=time_text,
                ip_text=ip_text
            )

            close_all_user_apps()
            break  # dừng script sau khi kill app

        # ✅ IPv4 bình thường
        send_report(
            cpu_percent=cpu_text,
            disk_gb=disk_text,
            time_text=time_text,
            ip_text=ip_text
        )

        # ⏳ 20 phút
        time.sleep(20 * 60)

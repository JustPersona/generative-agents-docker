from os import getenv as env

ollama_url = f"http://{env('OLLAMA_HOST')}:{env('OLLAMA_PORT')}"
ollama_model = f"{env('OLLAMA_MODEL_NAME')}"

dvwa_url = f"http://{env('DVWA_HOST')}"
server_path = "/source"

frontend_server_dir = f"{env('DATA_DIR')}{env('FRONTEND_SERVER_ROOT')}"
maze_assets_loc = f"{frontend_server_dir}/static/assets"
env_matrix = f"{maze_assets_loc}/%s/matrix"
env_visuals = f"{maze_assets_loc}/%s/visuals"

fs_storage = f"{frontend_server_dir}/storage"
fs_temp_storage = f"{frontend_server_dir}/temp_storage"

black_hats = ["Carlos Gomez", "Yuriko Yamamoto"]
white_hats = ["Abigail Chen", "Arthur Burton"]
server_owners = ["Isabella Rodriguez"]
work_areas = ["computer desk", "control screen"]

debug = True

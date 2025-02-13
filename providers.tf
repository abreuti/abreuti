terraform {
  required_providers {
    mgc = {
      source = "MagaluCloud/mgc"
      #version = "0.32.0"
    }
  }
}

#nordeste
provider "mgc" {
  alias   = "cloud"
  region  = "br-se1"
  api_key = "9250b02a-e79d-40dc-8d2a-fe29410be194"
  object_storage = {
    key_pair = {
      key_id     = "f238d1a1-e1ce-4d99-be0a-34fd92e0382d"
      key_secret = "af1a6081-99ee-4fb0-b823-fb1eb0a86ce9"

    }
  }
}
variable "yc_token" {
  description = "OAuth-токен Yandex Cloud"
  type        = string
  sensitive   = true
}

variable "yc_cloud_id" {
  description = "ID облака"
  type        = string
}

variable "yc_folder_id" {
  description = "ID каталога"
  type        = string
}

variable "yc_service_account_id" {
  description = "ID сервисного аккаунта для Instance Group"
  type        = string
}
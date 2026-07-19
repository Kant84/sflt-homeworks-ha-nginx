# Домашнее задание: Отказоустойчивость в облаке

**Выполнил:** Санакин А.В.

## Задание 1

### Terraform Playbook

- [main.tf](main.tf) — основная конфигурация
- [variables.tf](variables.tf) — переменные

### Результаты

**Балансировщик:**
- Имя: `nginx-lb`
- IP: `130.193.56.158`
- Статус: **Active**

**Целевая группа:**
- Имя: `nginx-target-group`
- Цели: `nginx-vm-1` (192.168.10.23), `nginx-vm-2` (192.168.10.3)
- Статус обеих: **Healthy**

### Скриншоты

1. Статус балансировщика и целевой группы:
   ![Балансировщик Active, цели Healthy](screenshot-lb.png)

2. Список виртуальных машин:
   ![2 ВМ Running](screenshot-vms.png)

3. Страница Nginx:
   ![Welcome to nginx!](screenshot-nginx.png)

COMPOSE_FILE = srcs/docker-compose.yaml
COMPOSE = docker compose -f $(COMPOSE_FILE)

GREEN = \033[0;32m
YELLOW = \033[0;33m
RESET = \033[0m

all: up

up: build
	@echo "$(YELLOW)Starting Inception...$(RESET)"
	@$(COMPOSE) up -d
	@echo "$(GREEN)Inception is running.$(RESET)"

build:
	@echo "$(YELLOW)Building images...$(RESET)"
	@$(COMPOSE) build
	@echo "$(GREEN)Images built.$(RESET)"

down:
	@echo "$(YELLOW)Stopping Inception...$(RESET)"
	@$(COMPOSE) down
	@echo "$(GREEN)Inception stopped.$(RESET)"

clean:
	@echo "$(YELLOW)Stopping containers and removing volumes...$(RESET)"
	@$(COMPOSE) down
	@echo "$(GREEN)Containers and volumes removed.$(RESET)"

fclean:
	@echo "$(YELLOW)Removing containers, volumes and images...$(RESET)"
	@$(COMPOSE) down -v --rmi all
	@echo "$(GREEN)Full cleanup done.$(RESET)"

re: fclean up

ps:
	@$(COMPOSE) ps

logs:
	@$(COMPOSE) logs -f

.PHONY: all up build down clean fclean re ps logs
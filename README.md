# SRE EKS GitOps Lab

Projeto prático de SRE para demonstrar provisionamento de infraestrutura,
Kubernetes, integração contínua, GitOps e observabilidade.

## Objetivo

Provisionar um cluster Amazon EKS utilizando Terraform, realizar o deploy
de uma aplicação com ArgoCD e monitorar o ambiente com Prometheus e Grafana.

## Tecnologias

- AWS
- Amazon EKS
- Terraform
- Kubernetes
- Docker
- GitHub Actions
- ArgoCD
- Prometheus
- Grafana
- Python
- Flask

## Arquitetura

O Terraform será responsável pelo provisionamento da infraestrutura AWS e
do cluster EKS.

O GitHub Actions executará testes, validações e a construção da imagem
Docker da aplicação.

O ArgoCD utilizará o repositório Git como fonte da verdade e sincronizará
os manifestos Kubernetes com o cluster.

O Prometheus coletará métricas da aplicação e do cluster, enquanto o
Grafana será utilizado para visualização e investigação.

## Endpoints

| Endpoint | Descrição |
|---|---|
| `/` | Informações da aplicação |
| `/health` | Health check |
| `/metrics` | Métricas Prometheus |
| `/simulate-latency` | Simulação de latência |
| `/simulate-error` | Simulação de erro HTTP 500 |

## Roadmap

- [x] Criar estrutura inicial
- [x] Criar aplicação
- [x] Adicionar health check
- [x] Adicionar métricas Prometheus
- [x] Adicionar testes automatizados
- [x] Criar Dockerfile
- [x] Executar aplicação em container
- [ ] Criar pipeline de testes no GitHub Actions
- [ ] Criar infraestrutura com Terraform
- [ ] Criar cluster EKS
- [ ] Criar manifests Kubernetes
- [ ] Instalar ArgoCD
- [ ] Instalar Prometheus e Grafana
- [ ] Criar dashboards e alertas
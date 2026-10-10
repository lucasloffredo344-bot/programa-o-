algoritmo "LogiFast"

tipo
   tipoEntrega = registro
      codigo: inteiro
      destinatario: caractere
      origem: inteiro
      destino: inteiro
      peso: real
      valorMercadoria: real
      prioridade: inteiro
      distancia: inteiro
      status: inteiro
      custo: real
   fimregistro

var
   MAX_ENTREGAS, MAX_REGIOES: inteiro
   URGENTE, PRIORITARIA, NORMAL: inteiro
   AGUARDANDO, EM_TRANSPORTE, ENTREGUE: inteiro
   VALOR_KM: real
   // o VisuAlg exige limites numericos nos vetores
   entregas: vetor[1..30] de tipoEntrega
   distancias: vetor[1..5,1..5] de inteiro
   percurso: vetor[1..5] de inteiro
   quantidadeEntregas, opcao: inteiro

funcao localizarEntrega(codigoProcurado: inteiro): inteiro
var
   i, posicaoEncontrada: inteiro
inicio
   posicaoEncontrada <- -1

   para i de 1 ate quantidadeEntregas faca
      se entregas[i].codigo = codigoProcurado entao
         posicaoEncontrada <- i
      fimse
   fimpara

   retorne posicaoEncontrada
fimfuncao

funcao calcularCusto(distanciaEntrega: inteiro; pesoEntrega: real; prioridadeEntrega: inteiro): real
var
   custoBase, adicionalPeso, adicionalPrioridade: real
inicio
   custoBase <- distanciaEntrega * VALOR_KM
   adicionalPeso <- 0
   adicionalPrioridade <- 0

   // os acrescimos sao calculados sobre o custo base
   // verifica o acrescimo pelo peso
   se pesoEntrega > 50 entao
      adicionalPeso <- custoBase * 0.35
   senao
      se pesoEntrega > 20 entao
         adicionalPeso <- custoBase * 0.20
      senao
         se pesoEntrega > 5 entao
            adicionalPeso <- custoBase * 0.10
         fimse
      fimse
   fimse

   // verifica o acrescimo pela prioridade
   se prioridadeEntrega = URGENTE entao
      adicionalPrioridade <- custoBase * 0.30
   senao
      se prioridadeEntrega = PRIORITARIA entao
         adicionalPrioridade <- custoBase * 0.15
      fimse
   fimse

   retorne custoBase + adicionalPeso + adicionalPrioridade
fimfuncao

funcao nomeRegiao(numeroRegiao: inteiro): caractere
var
   resultado: caractere
inicio
   escolha numeroRegiao
      caso 1
         resultado <- "Centro"
      caso 2
         resultado <- "Norte"
      caso 3
         resultado <- "Sul"
      caso 4
         resultado <- "Leste"
      caso 5
         resultado <- "Oeste"
      outrocaso
         resultado <- "Regiao invalida"
   fimescolha

   retorne resultado
fimfuncao

funcao nomePrioridade(numeroPrioridade: inteiro): caractere
var
   resultado: caractere
inicio
   escolha numeroPrioridade
      caso 1
         resultado <- "Urgente"
      caso 2
         resultado <- "Prioritaria"
      caso 3
         resultado <- "Normal"
      outrocaso
         resultado <- "Invalida"
   fimescolha

   retorne resultado
fimfuncao

funcao nomeStatus(numeroStatus: inteiro): caractere
var
   resultado: caractere
inicio
   escolha numeroStatus
      caso 1
         resultado <- "Aguardando"
      caso 2
         resultado <- "Em transporte"
      caso 3
         resultado <- "Entregue"
      outrocaso
         resultado <- "Invalido"
   fimescolha

   retorne resultado
fimfuncao

funcao calcularPercursoRecursivo(posicaoAtual, quantidadeRegioes: inteiro): inteiro
var
   distanciaTrecho: inteiro
inicio
   // caso base: chegou a ultima regiao
   se posicaoAtual >= quantidadeRegioes entao
      retorne 0
   senao
      distanciaTrecho <- distancias[percurso[posicaoAtual], percurso[posicaoAtual + 1]]

      // soma o trecho atual com a chamada recursiva
      retorne distanciaTrecho + calcularPercursoRecursivo(posicaoAtual + 1, quantidadeRegioes)
   fimse
fimfuncao

procedimento inicializarMatriz
inicio
   // distancias partindo do Centro
   distancias[1,1] <- 0
   distancias[1,2] <- 12
   distancias[1,3] <- 15
   distancias[1,4] <- 10
   distancias[1,5] <- 14

   // distancias partindo do Norte
   distancias[2,1] <- 12
   distancias[2,2] <- 0
   distancias[2,3] <- 25
   distancias[2,4] <- 18
   distancias[2,5] <- 20

   // distancias partindo do Sul
   distancias[3,1] <- 15
   distancias[3,2] <- 25
   distancias[3,3] <- 0
   distancias[3,4] <- 16
   distancias[3,5] <- 19

   // distancias partindo do Leste
   distancias[4,1] <- 10
   distancias[4,2] <- 18
   distancias[4,3] <- 16
   distancias[4,4] <- 0
   distancias[4,5] <- 22

   // distancias partindo do Oeste
   distancias[5,1] <- 14
   distancias[5,2] <- 20
   distancias[5,3] <- 19
   distancias[5,4] <- 22
   distancias[5,5] <- 0
fimprocedimento

procedimento mostrarEntrega(posicao: inteiro)
inicio
   escreval("Codigo: ", entregas[posicao].codigo)
   escreval("Destinatario: ", entregas[posicao].destinatario)
   escreval("Origem: ", nomeRegiao(entregas[posicao].origem))
   escreval("Destino: ", nomeRegiao(entregas[posicao].destino))
   escreval("Peso: ", entregas[posicao].peso:8:2, " kg")
   escreval("Valor da mercadoria: R$ ", entregas[posicao].valorMercadoria:8:2)
   escreval("Prioridade: ", nomePrioridade(entregas[posicao].prioridade))
   escreval("Distancia: ", entregas[posicao].distancia, " km")
   escreval("Status: ", nomeStatus(entregas[posicao].status))
   escreval("Custo estimado: R$ ", entregas[posicao].custo:8:2)
fimprocedimento

procedimento cadastrarEntrega
var
   codigoNovo, posicaoEncontrada, i: inteiro
   origemNova, destinoNova, prioridadeNova: inteiro
   pesoNovo, valorNovo: real
   destinatarioNovo: caractere
   codigoExiste: logico
inicio
   se quantidadeEntregas >= MAX_ENTREGAS entao
      escreval("A capacidade maxima de entregas foi atingida.")
   senao
      escreval("Codigo da entrega (maior que zero): ")
      leia(codigoNovo)

      enquanto codigoNovo <= 0 faca
         escreval("Codigo invalido. Digite um codigo maior que zero: ")
         leia(codigoNovo)
      fimenquanto

      codigoExiste <- falso
      posicaoEncontrada <- localizarEntrega(codigoNovo)

      se posicaoEncontrada <> -1 entao
         codigoExiste <- verdadeiro
      fimse

      enquanto codigoExiste = verdadeiro faca
         escreval("Esse codigo ja existe. Digite outro codigo: ")
         leia(codigoNovo)

         enquanto codigoNovo <= 0 faca
            escreval("Codigo invalido. Digite um codigo maior que zero: ")
            leia(codigoNovo)
         fimenquanto

         codigoExiste <- falso
         para i de 1 ate quantidadeEntregas faca
            se entregas[i].codigo = codigoNovo entao
               codigoExiste <- verdadeiro
            fimse
         fimpara
      fimenquanto

      escreval("Nome do destinatario ou descricao: ")
      leia(destinatarioNovo)
      enquanto destinatarioNovo = "" faca
         escreval("O destinatario nao pode ficar vazio. Digite novamente: ")
         leia(destinatarioNovo)
      fimenquanto

      escreval("Regiao de origem (1-Centro, 2-Norte, 3-Sul, 4-Leste, 5-Oeste): ")
      leia(origemNova)
      enquanto (origemNova < 1) ou (origemNova > MAX_REGIOES) faca
         escreval("Origem invalida. Digite uma regiao de 1 a 5: ")
         leia(origemNova)
      fimenquanto

      escreval("Regiao de destino (1-Centro, 2-Norte, 3-Sul, 4-Leste, 5-Oeste): ")
      leia(destinoNova)
      enquanto (destinoNova < 1) ou (destinoNova > MAX_REGIOES) faca
         escreval("Destino invalido. Digite uma regiao de 1 a 5: ")
         leia(destinoNova)
      fimenquanto

      enquanto origemNova = destinoNova faca
         escreval("Origem e destino devem ser diferentes.")
         escreval("Digite novamente a regiao de destino: ")
         leia(destinoNova)
         enquanto (destinoNova < 1) ou (destinoNova > MAX_REGIOES) faca
            escreval("Destino invalido. Digite uma regiao de 1 a 5: ")
            leia(destinoNova)
         fimenquanto
      fimenquanto

      escreval("Peso da entrega em kg: ")
      leia(pesoNovo)
      enquanto pesoNovo <= 0 faca
         escreval("O peso deve ser maior que zero. Digite novamente: ")
         leia(pesoNovo)
      fimenquanto

      escreval("Valor da mercadoria: ")
      leia(valorNovo)
      enquanto valorNovo < 0 faca
         escreval("O valor nao pode ser negativo. Digite novamente: ")
         leia(valorNovo)
      fimenquanto

      escreval("Prioridade (1-Urgente, 2-Prioritaria, 3-Normal): ")
      leia(prioridadeNova)
      enquanto (prioridadeNova < URGENTE) ou (prioridadeNova > NORMAL) faca
         escreval("Prioridade invalida. Digite 1, 2 ou 3: ")
         leia(prioridadeNova)
      fimenquanto

      quantidadeEntregas <- quantidadeEntregas + 1
      entregas[quantidadeEntregas].codigo <- codigoNovo
      entregas[quantidadeEntregas].destinatario <- destinatarioNovo
      entregas[quantidadeEntregas].origem <- origemNova
      entregas[quantidadeEntregas].destino <- destinoNova
      entregas[quantidadeEntregas].peso <- pesoNovo
      entregas[quantidadeEntregas].valorMercadoria <- valorNovo
      entregas[quantidadeEntregas].prioridade <- prioridadeNova
      entregas[quantidadeEntregas].distancia <- distancias[origemNova,destinoNova]
      entregas[quantidadeEntregas].status <- AGUARDANDO
      entregas[quantidadeEntregas].custo <- calcularCusto(entregas[quantidadeEntregas].distancia, pesoNovo, prioridadeNova)

      escreval("Entrega cadastrada com sucesso.")
      escreval("Distancia calculada: ", entregas[quantidadeEntregas].distancia, " km")
      escreval("Custo estimado: R$ ", entregas[quantidadeEntregas].custo:8:2)
   fimse
fimprocedimento

procedimento listarEntregas
var
   i: inteiro
inicio
   se quantidadeEntregas = 0 entao
      escreval("Nao ha entregas cadastradas.")
   senao
      escreval("===== ENTREGAS CADASTRADAS =====")
      para i de 1 ate quantidadeEntregas faca
         escreval("--------------------------------")
         mostrarEntrega(i)
      fimpara
   fimse
fimprocedimento

procedimento consultarEntrega
var
   codigoConsulta, posicao: inteiro
inicio
   escreval("Digite o codigo da entrega: ")
   leia(codigoConsulta)
   posicao <- localizarEntrega(codigoConsulta)

   se posicao = -1 entao
      escreval("Entrega nao encontrada.")
   senao
      mostrarEntrega(posicao)
   fimse
fimprocedimento

procedimento exibirFila
var
   fila: vetor[1..30] de inteiro
   quantidadeFila, i, j: inteiro
   temporaria: inteiro
   deveTrocar: logico
inicio
   quantidadeFila <- 0

   // copia para a fila somente as entregas aguardando
   para i de 1 ate quantidadeEntregas faca
      se entregas[i].status = AGUARDANDO entao
         quantidadeFila <- quantidadeFila + 1
         fila[quantidadeFila] <- i
      fimse
   fimpara

   se quantidadeFila = 0 entao
      escreval("Nao ha entregas aguardando despacho.")
   senao
      // ordena a copia com Bubble Sort
      se quantidadeFila > 1 entao
         para i de 1 ate quantidadeFila - 1 faca
            para j de 1 ate quantidadeFila - i faca
               deveTrocar <- falso

               // primeiro criterio: menor numero de prioridade
               se entregas[fila[j]].prioridade > entregas[fila[j + 1]].prioridade entao
                  deveTrocar <- verdadeiro
               senao
                  se entregas[fila[j]].prioridade = entregas[fila[j + 1]].prioridade entao
                     // segundo criterio: maior valor da mercadoria
                     se entregas[fila[j]].valorMercadoria < entregas[fila[j + 1]].valorMercadoria entao
                        deveTrocar <- verdadeiro
                     senao
                        se entregas[fila[j]].valorMercadoria = entregas[fila[j + 1]].valorMercadoria entao
                           // terceiro criterio: maior peso
                           se entregas[fila[j]].peso < entregas[fila[j + 1]].peso entao
                              deveTrocar <- verdadeiro
                           senao
                              se entregas[fila[j]].peso = entregas[fila[j + 1]].peso entao
                                 // quarto criterio: menor codigo
                                 se entregas[fila[j]].codigo > entregas[fila[j + 1]].codigo entao
                                    deveTrocar <- verdadeiro
                                 fimse
                              fimse
                           fimse
                        fimse
                     fimse
                  fimse
               fimse

               se deveTrocar = verdadeiro entao
                  temporaria <- fila[j]
                  fila[j] <- fila[j + 1]
                  fila[j + 1] <- temporaria
               fimse
            fimpara
         fimpara
      fimse

      escreval("===== FILA DE DESPACHO =====")
      para i de 1 ate quantidadeFila faca
         escreval("--------------------------------")
         escreval("Posicao na fila: ", i)
         escreval("Codigo: ", entregas[fila[i]].codigo)
         escreval("Destinatario: ", entregas[fila[i]].destinatario)
         escreval("Origem: ", nomeRegiao(entregas[fila[i]].origem))
         escreval("Destino: ", nomeRegiao(entregas[fila[i]].destino))
         escreval("Prioridade: ", nomePrioridade(entregas[fila[i]].prioridade))
         escreval("Valor da mercadoria: R$ ", entregas[fila[i]].valorMercadoria:8:2)
         escreval("Peso: ", entregas[fila[i]].peso:8:2, " kg")
         escreval("Distancia: ", entregas[fila[i]].distancia, " km")
      fimpara
   fimse
fimprocedimento

procedimento iniciarTransporte
var
   codigoConsulta, posicao: inteiro
inicio
   escreval("Digite o codigo da entrega para iniciar o transporte: ")
   leia(codigoConsulta)
   posicao <- localizarEntrega(codigoConsulta)

   se posicao = -1 entao
      escreval("Entrega nao encontrada.")
   senao
      se entregas[posicao].status = AGUARDANDO entao
         entregas[posicao].status <- EM_TRANSPORTE
         escreval("Entrega agora esta em transporte.")
      senao
         se entregas[posicao].status = EM_TRANSPORTE entao
            escreval("Essa entrega ja esta em transporte.")
         senao
            escreval("Uma entrega finalizada nao pode voltar ao transporte.")
         fimse
      fimse
   fimse
fimprocedimento

procedimento finalizarEntrega
var
   codigoConsulta, posicao: inteiro
inicio
   escreval("Digite o codigo da entrega para finalizar: ")
   leia(codigoConsulta)
   posicao <- localizarEntrega(codigoConsulta)

   se posicao = -1 entao
      escreval("Entrega nao encontrada.")
   senao
      se entregas[posicao].status = EM_TRANSPORTE entao
         entregas[posicao].status <- ENTREGUE
         escreval("Entrega finalizada com sucesso.")
      senao
         se entregas[posicao].status = AGUARDANDO entao
            escreval("Inicie o transporte antes de finalizar a entrega.")
         senao
            escreval("Essa entrega ja foi finalizada.")
         fimse
      fimse
   fimse
fimprocedimento

procedimento exibirMatriz
var
   i, j, maiorDistancia, menorDistancia, quantidadeTrechos: inteiro
   somaDistancias, mediaDistancias: real
inicio
   escreval("===== MATRIZ DE DISTANCIAS (KM) =====")
   escreval("             Centro Norte Sul Leste Oeste")

   para i de 1 ate MAX_REGIOES faca
      escreva(nomeRegiao(i), " ")
      para j de 1 ate MAX_REGIOES faca
         escreva(distancias[i,j]:6)
      fimpara
      escreval("")
   fimpara

   maiorDistancia <- 0
   menorDistancia <- 0
   somaDistancias <- 0
   quantidadeTrechos <- 0

   // percorre a matriz sem considerar a diagonal
   para i de 1 ate MAX_REGIOES faca
      para j de 1 ate MAX_REGIOES faca
         se i <> j entao
            somaDistancias <- somaDistancias + distancias[i,j]
            quantidadeTrechos <- quantidadeTrechos + 1

            se distancias[i,j] > maiorDistancia entao
               maiorDistancia <- distancias[i,j]
            fimse

            se menorDistancia = 0 entao
               menorDistancia <- distancias[i,j]
            senao
               se distancias[i,j] < menorDistancia entao
                  menorDistancia <- distancias[i,j]
               fimse
            fimse
         fimse
      fimpara
   fimpara

   se quantidadeTrechos > 0 entao
      mediaDistancias <- somaDistancias / quantidadeTrechos
      escreval("Maior distancia: ", maiorDistancia, " km")
      escreval("Menor distancia diferente de zero: ", menorDistancia, " km")
      escreval("Media das distancias entre regioes: ", mediaDistancias:8:2, " km")
   fimse
fimprocedimento

procedimento exibirEstatisticas
var
   i, regiao, maiorRegiao: inteiro
   quantidadeAguardando, emTransporte, entreguesFinalizadas: inteiro
   urgentes, prioritarias, normais: inteiro
   entregaMaiorValor, entregaMaiorPeso, entregaMaiorDistancia: inteiro
   contagemRegioes: vetor[1..5] de inteiro
   pesoTotal, mediaPeso, valorTotal, mediaValor: real
   custoTotal, custoMedio: real
inicio
   se quantidadeEntregas = 0 entao
      escreval("Nao ha dados para calcular as estatisticas.")
   senao
      quantidadeAguardando <- 0
      emTransporte <- 0
      entreguesFinalizadas <- 0
      urgentes <- 0
      prioritarias <- 0
      normais <- 0
      pesoTotal <- 0
      valorTotal <- 0
      custoTotal <- 0

      para regiao de 1 ate MAX_REGIOES faca
         contagemRegioes[regiao] <- 0
      fimpara

      entregaMaiorValor <- 1
      entregaMaiorPeso <- 1
      entregaMaiorDistancia <- 1

      para i de 1 ate quantidadeEntregas faca
         se entregas[i].status = AGUARDANDO entao
            quantidadeAguardando <- quantidadeAguardando + 1
         senao
            se entregas[i].status = EM_TRANSPORTE entao
               emTransporte <- emTransporte + 1
            senao
               se entregas[i].status = ENTREGUE entao
                  entreguesFinalizadas <- entreguesFinalizadas + 1
               fimse
            fimse
         fimse

         se entregas[i].prioridade = URGENTE entao
            urgentes <- urgentes + 1
         senao
            se entregas[i].prioridade = PRIORITARIA entao
               prioritarias <- prioritarias + 1
            senao
               se entregas[i].prioridade = NORMAL entao
                  normais <- normais + 1
               fimse
            fimse
         fimse

         pesoTotal <- pesoTotal + entregas[i].peso
         valorTotal <- valorTotal + entregas[i].valorMercadoria
         custoTotal <- custoTotal + entregas[i].custo
         contagemRegioes[entregas[i].destino] <- contagemRegioes[entregas[i].destino] + 1

         se entregas[i].valorMercadoria > entregas[entregaMaiorValor].valorMercadoria entao
            entregaMaiorValor <- i
         fimse

         se entregas[i].peso > entregas[entregaMaiorPeso].peso entao
            entregaMaiorPeso <- i
         fimse

         se entregas[i].distancia > entregas[entregaMaiorDistancia].distancia entao
            entregaMaiorDistancia <- i
         fimse
      fimpara

      mediaPeso <- pesoTotal / quantidadeEntregas
      mediaValor <- valorTotal / quantidadeEntregas
      custoMedio <- custoTotal / quantidadeEntregas

      maiorRegiao <- 1
      para regiao de 2 ate MAX_REGIOES faca
         se contagemRegioes[regiao] > contagemRegioes[maiorRegiao] entao
            maiorRegiao <- regiao
         fimse
      fimpara

      escreval("===== ESTATISTICAS =====")
      escreval("Quantidade total de entregas: ", quantidadeEntregas)
      escreval("Aguardando: ", quantidadeAguardando)
      escreval("Em transporte: ", emTransporte)
      escreval("Entregues: ", entreguesFinalizadas)
      escreval("Prioridade urgente: ", urgentes)
      escreval("Prioridade prioritaria: ", prioritarias)
      escreval("Prioridade normal: ", normais)
      escreval("Peso total: ", pesoTotal:8:2, " kg")
      escreval("Peso medio: ", mediaPeso:8:2, " kg")
      escreval("Valor total das mercadorias: R$ ", valorTotal:8:2)
      escreval("Valor medio das mercadorias: R$ ", mediaValor:8:2)
      escreval("Custo total estimado: R$ ", custoTotal:8:2)
      escreval("Custo medio estimado: R$ ", custoMedio:8:2)
      escreval("Entrega de maior valor: codigo ", entregas[entregaMaiorValor].codigo, " - R$ ", entregas[entregaMaiorValor].valorMercadoria:8:2)
      escreval("Entrega de maior peso: codigo ", entregas[entregaMaiorPeso].codigo, " - ", entregas[entregaMaiorPeso].peso:8:2, " kg")
      escreval("Entrega de maior distancia: codigo ", entregas[entregaMaiorDistancia].codigo, " - ", entregas[entregaMaiorDistancia].distancia, " km")
      escreval("Regiao que recebeu mais entregas: ", nomeRegiao(maiorRegiao), " (", contagemRegioes[maiorRegiao], ")")
   fimse
fimprocedimento

procedimento calcularPercurso
var
   quantidadeRegioes, i, regiaoDigitada, distanciaTotal: inteiro
inicio
   escreval("O percurso deve ter de 2 a ", MAX_REGIOES, " regioes.")
   escreval("Quantidade de regioes no percurso: ")
   leia(quantidadeRegioes)

   enquanto (quantidadeRegioes < 2) ou (quantidadeRegioes > MAX_REGIOES) faca
      escreval("Quantidade invalida. Digite um valor de 2 a ", MAX_REGIOES, ": ")
      leia(quantidadeRegioes)
   fimenquanto

   para i de 1 ate quantidadeRegioes faca
      escreval("Regiao ", i, " (1-Centro, 2-Norte, 3-Sul, 4-Leste, 5-Oeste): ")
      leia(regiaoDigitada)

      enquanto (regiaoDigitada < 1) ou (regiaoDigitada > MAX_REGIOES) faca
         escreval("Regiao invalida. Digite um valor de 1 a 5: ")
         leia(regiaoDigitada)
      fimenquanto

      percurso[i] <- regiaoDigitada
   fimpara

   escreva("Percurso: ")
   para i de 1 ate quantidadeRegioes faca
      escreva(nomeRegiao(percurso[i]))
      se i < quantidadeRegioes entao
         escreva(" -> ")
      fimse
   fimpara
   escreval("")

   distanciaTotal <- calcularPercursoRecursivo(1, quantidadeRegioes)
   escreval("Distancia total do percurso: ", distanciaTotal, " km")
fimprocedimento

inicio
   // valores fixos usados pelo sistema
   MAX_ENTREGAS <- 30
   MAX_REGIOES <- 5
   URGENTE <- 1
   PRIORITARIA <- 2
   NORMAL <- 3
   AGUARDANDO <- 1
   EM_TRANSPORTE <- 2
   ENTREGUE <- 3
   VALOR_KM <- 2.50

   quantidadeEntregas <- 0
   opcao <- 0
   inicializarMatriz

   enquanto opcao <> 10 faca
      escreval("")
      escreval("LOGIFAST - SISTEMA DE GERENCIAMENTO DE ENTREGAS")
      escreval("1. Cadastrar entrega")
      escreval("2. Listar entregas")
      escreval("3. Consultar entrega")
      escreval("4. Exibir fila de despacho")
      escreval("5. Iniciar transporte")
      escreval("6. Finalizar entrega")
      escreval("7. Exibir matriz de distancias")
      escreval("8. Exibir estatisticas")
      escreval("9. Calcular percurso recursivamente")
      escreval("10. Encerrar sistema")
      escreva("Escolha uma opcao: ")
      leia(opcao)

      escolha opcao
         caso 1
            cadastrarEntrega
         caso 2
            listarEntregas
         caso 3
            consultarEntrega
         caso 4
            exibirFila
         caso 5
            iniciarTransporte
         caso 6
            finalizarEntrega
         caso 7
            exibirMatriz
         caso 8
            exibirEstatisticas
         caso 9
            calcularPercurso
         caso 10
            escreval("Sistema encerrado.")
         outrocaso
            escreval("Opcao invalida. Escolha um numero de 1 a 10.")
      fimescolha
   fimenquanto
fimalgoritmo

require 'sinatra'
require 'nokogiri'
require 'mongo'
require 'json'
require 'open-uri'
require 'net/http'

# Conexão com o MongoDB
client = Mongo::Client.new('mongodb://localhost:27017/similarweb')
collection = client[:websites]

# Função para fazer scraping do SimilarWeb
def scrape_similarweb(url)
  # Adicionando cabeçalho para simular o comportamento em um navegador
  uri = URI.parse("https://www.similarweb.com/pt/website/tgifridays.com/")
  request = Net::HTTP::Get.new(uri)
  request["Accept"] = "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7"
  request["Accept-Language"] = "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7"
  request["Cache-Control"] = "max-age=0"
  request["Cookie"] = "sgID=656804ab-91ec-4388-af3d-70f8396710c9; OptanonAlertBoxClosed=2024-03-20T19:25:56.639Z; locale=pt-br; __q_state_9u7uiM39FyWVMWQF=eyJ1dWlkIjoiMDk3NGQ0NmEtYTg1ZC00OGU4LWFjZjQtMjZhNjYzZTMwOTRjIiwiY29va2llRG9tYWluIjoic2ltaWxhcndlYi5jb20iLCJtZXNzZW5nZXJFeHBhbmRlZCI6ZmFsc2UsInByb21wdERpc21pc3NlZCI6ZmFsc2UsImNvbnZlcnNhdGlvbklkIjoiMTM1NzQ2ODgxNjk2OTAwMDA3NCJ9; RESET_PRO_CACHE=true; bm_sz=966220D6653C66E07E8CC55E5E6F8B50~YAAQlKYRyfrbEoWOAQAAqzxwjxfjuJvN0tCAP010M7HzMTz54tI3R5yLHh4EwrsCLwyLEj9QQuiTkIKShJkasK6ZYYrEdxdYT6/Eb1wfZc3sYL2z07iQN5qyzdzwIyT4Eih7n6vJVdMzpuuez+KdM84Vxl63gcJQgYsTg23kU4XaS3NE1ZXSJc/wXelpBiU4Dxjmg1RcmEz5TMCtonO63AiE1kjZDc0/llqh7KaizEGqJgxkU3yu82Wf2ADTj83rKd5kuE8CeWbVyBkVHIVAHQmHLEZpXc76QrEqqv+YV4HbVmsWe+8pkkC4eSBxoWD+TzEGbiFzExp5cAnFOoWGcveU/XS7RwOyhBqvLbzDrsI+9ILaKFYOpfa+~3223875~3487031; ak_bmsc=62A17C0545CCD7E342901DC6659DDB20~000000000000000000000000000000~YAAQlKYRyf7bEoWOAQAAVkNwjxfs2OASLS3pGTj13EE3z/zRF0h0HUa0sEZWdDMu1kWoU5cAlwqoPI3X+V9DmUaEkosKQZ37iyGyht4DL151lu2iPC+kJXpECEFOsa4637kTIim7yPI4gY8/8pdjQhNxf/47ZLBmx9NlmI5zpeqNIvOqbVLOW7tPnv/sKstSM0bD5h7+2mjDyGXQ7Yyg8jozNgLMw0xC/NduCIY2sweLOldDwUszUaHvezsU3xl74SsqbIHB91IbBKvLqxYy8P6ADEq9yAd2WTQdEQlKXfwropUQjfsdt2fuuF21Ly50BB6kBjT4nVmr1gzPOhgnJIfrsAU3piPAlIOkw7wYwGTyw1syqkL3Cjdvf9V0dCd+imGQJdBRbtb3g/hWnKc=; _abck=5D1AFCD9DAAC51CB94B7EA87056C17F8~0~YAAQlKYRyQDcEoWOAQAAgUZwjwt8gbUQb/rRJZi2Let7SFXgg5lr9mDZtTDjeRsCPOBSxSxt2sY5ubiwctoK27O6tSU8A8TTi2ln0/3k3v03dkUFW5bR4aYeqw8z463xY9h8TlJB64CAREMS3iWL206k56gqKosDWqnqldIALFzY/gJO2+ABeDntacEUsk0g2BJtRbNobOjyz6ypYhLU3Jc11zMEPI8+VCfk5T0dx3qknPoDcLtqfEmkLNhMVGLFJJRGBLMdzPQIQS9Ihn3VwamxLkRzTkb0Vk5syIV9mbpSPe7l8Cp9SUjTT16LAa2ntswetLMpfDmmOYRVP/m17iL6LbxPS4BZUHKsHu+Pt1qncajIpJV+yJy7oRNWlTVf+QKI/duV0QXOJUCgaZJ1q52/PHJfSgHXgYP6~-1~-1~-1; OptanonConsent=isGpcEnabled=0&datestamp=Sat+Mar+30+2024+09%3A58%3A04+GMT-0300+(Hor%C3%A1rio+Padr%C3%A3o+de+Bras%C3%ADlia)&version=202306.2.0&browserGpcFlag=0&isIABGlobal=false&hosts=&consentId=6431c288-a470-4474-930f-938640acf92a&interactionCount=2&landingPath=NotLandingPage&groups=C0003%3A1%2CC0004%3A1%2CC0002%3A1%2CC0001%3A1&AwaitingReconsent=false&geolocation=BR%3BMG; loyal-user={%22date%22:%222024-03-30T12:58:04.222Z%22%2C%22isLoyal%22:false}"
  request["Sec-Ch-Ua"] = "\"Google Chrome\";v=\"123\", \"Not:A-Brand\";v=\"8\", \"Chromium\";v=\"123\""
  request["Sec-Ch-Ua-Mobile"] = "?0"
  request["Sec-Ch-Ua-Platform"] = "\"Linux\""
  request["Sec-Fetch-Dest"] = "document"
  request["Sec-Fetch-Mode"] = "navigate"
  request["Sec-Fetch-Site"] = "same-origin"
  request["Sec-Fetch-User"] = "?1"
  request["Upgrade-Insecure-Requests"] = "1"
  request["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"
  
  req_options = {
    use_ssl: uri.scheme == "https",
  }
  
  response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(request)
  end
  
  html_doc = Nokogiri::HTML(response.body)

  # Tratando as informações para serem alimentadas corretamente no banco
  rankings = html_doc.css('.wa-rank-list__value').text.strip.split('#')

  data = {}
  data['site'] = url
  data['global_ranking'] = rankings[1]
  data['country_ranking'] = rankings[2]
  data['category_ranking'] = rankings[3]
  
  data
end

# Endpoint para salvar informações
post '/save_info' do
  url = JSON.parse(request.body.read)['url']

  if url.nil? || url.empty?
    status 400
    body JSON.generate(error: 'URL não fornecida')
  else
    data = scrape_similarweb(url)

    if data.empty?
      status 404
      body JSON.generate(error: 'Não foi possível encontrar informações para a URL fornecida')
    else
      result = collection.insert_one(data)
      status 201
      body JSON.generate(message: 'Informações salvas com sucesso', id: result.inserted_id.to_s)
    end
  end
end

# Endpoint para obter informações
post '/get_info' do
  url = JSON.parse(request.body.read)['url']

  if url.nil? || url.empty?
    status 400
    body JSON.generate(error: 'URL não fornecida')
  else
    data = collection.find(site: url).to_a.last

    if data.nil?
      status 404
      body JSON.generate(error: 'Informações não encontradas para a URL fornecida')
    else
      status 200
      body JSON.generate(data)
    end
  end
end

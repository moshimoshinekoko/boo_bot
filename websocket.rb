require 'http'
require 'json'
require 'eventmachine'
require 'faye/websocket'

response = HTTP.post("https://slack.com/api/rtm.start", params: {
    token: ENV['SLACK_API_TOKEN']
  })

rc = JSON.parse(response.body)

url = rc['url']

EM.run do
  # Web Socketインスタンスの立ち上げ
  ws = Faye::WebSocket::Client.new(url)

  #  接続が確立した時の処理
  ws.on :open do
    p [:open]
  end

  # RTM APIから情報を受け取った時の処理
  ws.on :message do |event|
    p [:message, JSON.parse(event.data)]
  end

  # 接続が切断した時の処理
  ws.on :close do
    p [:close, event.code]
    ws = nil
    EM.stop
  end

end

__END__
event.dataの中身
{"type"=>"message",
  "deleted_ts"=>"1523259194.000154",
  "subtype"=>"message_deleted",
  "hidden"=>true,
  "channel"=>"C86840P99",
  "previous_message"=>{
    "type"=>"message",
    "user"=>"U9BG3HL7Q",
    "text"=>"ｔｓ",
    "ts"=>"1523259194.000154"
    },
  "event_ts"=>"1523259200.000141",
  "ts"=>"1523259200.000141"}

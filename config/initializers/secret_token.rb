Mercator::Application.config.secret_token = CONFIG[:secret_token]
Mercator::Application.config.secret_key_base = CONFIG[:secret_key_base]

# encryption = OpenSSL::PKey::RSA.new File.read "path/to/keyfile"
# encryption.private_encrypt("0001").unpack("H*")[0]

begin
  decryption = OpenSSL::PKey::RSA.new(File.read(Rails.root + 'materials/id_rsa.pub.pem'))
  message = decryption.public_decrypt(["aa541b66696ab8b87019d4575c9218a9a1db3ff9ca9ffa8147e8e30054eef92a6a80b24ed3abd479e6ca7d761b2" + "1ef8f0f1254e7a1ca64834174e0db35eabf76bb403aa8a602e375614a2908d2fa774c0b39e18b3dd9c3b0d7bc60" + "752175481e996aa839a233f44eaec90f4a3e5b6629a140119f7e6c2f1fe5d4418c6bacc721794b512bde3115771" + "861c4577b8cbf18792012af4c193375a56f6bb6c8a98b3b39052e8eac83afebf5952e3c8c54c7ab5bf4369a7f8c" + "9991de9f133c67cd3504556f5ee9a2997fb38074ffa8d21fc053e63377d93fbce0fc23e37902183fd09b7acdb02" + "af0259080ac0d8bf2f451eb18b4179ebc87e12810fa50fb2dbdea5591a0341f048ea6d401a53ff5850af6d34bf4" + "c7260e0fe93c0eb00081ff752e0f503ee9c6fe2ffa954cda7db617c4f6943e9391acfe4824de9910bf3feddb5e5" + "2b22b267c81bc15f9596265a36f6c27dc5e4276c2cb9e59d30723f26b574277ee7066f58ded31f0b2e9baeb3311" + "f95138b4821e7e5b692adebeb676fae522d5a533f652e8e45f39897ec7b2ffe1bb96e5b19355e8ab9481106faf5" + "130ff9276c5d85e370663f3dccb3f0475ee3d1018f3f2baabc4faace99900e5eeac1894eefa32ebbdf4965a2374" + "529ed2ef1c8689af1747b59ed5a23876b22193c236b1e0c8a95dee28ccdae2e3e3f1f6b130be1bc5796ac07a455" + "72fd4c58858c016da32347b"].pack("H*"))
  unless decryption.public_decrypt([CONFIG[:system_key]].pack("H*")) == CONFIG[:system_id]
    puts message
    exit
  end
rescue
  puts message
  exit
end
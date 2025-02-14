const express = require('express');
const router = express.Router();
const User = require('../models/usuarios')



// Rota para obter a imagem de perfil do usuário
router.get('/users/:id/profile-image', async (req, res) => {
    try {
      const userId = req.params.id;
  
      const user = await User.findById(userId);
      if (!user || !user.profileImage) {
        return res.status(404).send({ message: 'Imagem de perfil não encontrada' });
      }
  
      res.status(200).send({ profileImage: user.profileImage });
    } catch (error) {
      res.status(500).send({ message: 'Erro ao obter a imagem de perfil', error });
    }
  });

module.exports = router;  
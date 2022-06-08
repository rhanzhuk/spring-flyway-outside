package com.rnganzhuk.springflywayoutside.service;

import com.rnganzhuk.springflywayoutside.entity.Client;
import com.rnganzhuk.springflywayoutside.repository.ClientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class ClientService {

    @Autowired
    ClientRepository clientRepository;

    public Optional<Client> getClient(int id){
        return clientRepository.findById(id);
    }
}

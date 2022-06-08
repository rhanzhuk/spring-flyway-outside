package com.rnganzhuk.springflywayoutside.controller;

import com.rnganzhuk.springflywayoutside.entity.Client;
import com.rnganzhuk.springflywayoutside.service.ClientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Optional;

@RestController
public class ClientController {

    @Autowired
    ClientService clientService;

    @GetMapping(path = "/client/{id}")
    public @ResponseBody Optional<Client> getClient(@PathVariable(value = "id") int id){
        return clientService.getClient(id);
    }
}

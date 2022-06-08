package com.rnganzhuk.springflywayoutside.repository;

import com.rnganzhuk.springflywayoutside.entity.Client;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ClientRepository extends JpaRepository<Client, Integer> {
}

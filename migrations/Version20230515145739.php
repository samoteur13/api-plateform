<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20230515145739 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TEMPORARY TABLE __temp__book AS SELECT id, title, author, year FROM book');
        $this->addSql('DROP TABLE book');
        $this->addSql('CREATE TABLE book (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, category_id INTEGER DEFAULT NULL, title VARCHAR(255) NOT NULL, author VARCHAR(255) NOT NULL, year VARCHAR(4) DEFAULT NULL, CONSTRAINT FK_CBE5A33112469DE2 FOREIGN KEY (category_id) REFERENCES category (id) NOT DEFERRABLE INITIALLY IMMEDIATE)');
        $this->addSql('INSERT INTO book (id, title, author, year) SELECT id, title, author, year FROM __temp__book');
        $this->addSql('DROP TABLE __temp__book');
        $this->addSql('CREATE INDEX IDX_CBE5A33112469DE2 ON book (category_id)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('CREATE TEMPORARY TABLE __temp__book AS SELECT id, title, author, year FROM book');
        $this->addSql('DROP TABLE book');
        $this->addSql('CREATE TABLE book (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title VARCHAR(255) NOT NULL, author VARCHAR(255) NOT NULL, year VARCHAR(4) DEFAULT NULL)');
        $this->addSql('INSERT INTO book (id, title, author, year) SELECT id, title, author, year FROM __temp__book');
        $this->addSql('DROP TABLE __temp__book');
    }
}

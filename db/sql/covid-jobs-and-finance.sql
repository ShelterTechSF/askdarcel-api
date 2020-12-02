-- Covid Job Category and Subcategories
Insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured) values 
(1000009, '20-SEP-20', '20-SEP-20', 'Covid-jobs', 't', null, 'f');

Insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured) values 
(1100032, '20-SEP-20', '20-SEP-20', 'Job Placement Support', 'f', null, 'f');

Insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured) values 
(1100033, '20-SEP-20', '20-SEP-20', 'Vocational Training Programs', 'f', null, 'f');

Insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured) values 
(1100034, '20-SEP-20', '20-SEP-20', 'Job Board', 'f', null, 'f');

-- Subcategory Relations
insert into category_relationships (parent_id, child_id) values 
(1000009,1100032);

insert into category_relationships (parent_id, child_id) values 
(1000009,1100033);

insert into category_relationships (parent_id, child_id) values 
(1000009,11000034);

insert into categories_services (category_id, service_id) values (1000009, 2300);
insert into categories_services (category_id, service_id) values (1000009, 1070);
insert into categories_services (category_id, service_id) values (1000009, 624);
insert into categories_services (category_id, service_id) values (1000009, 194);
insert into categories_services (category_id, service_id) values (1000009, 2512);
insert into categories_services (category_id, service_id) values (1000009, 2503);
insert into categories_services (category_id, service_id) values (1000009, 486); 
insert into categories_services (category_id, service_id) values (1000009, 2881);
insert into categories_services (category_id, service_id) values (1000009, 2882);
insert into categories_services (category_id, service_id) values (1000009, 2676);
insert into categories_services (category_id, service_id) values (1000009, 1438);
insert into categories_services (category_id, service_id) values (1000009, 1648);
insert into categories_services (category_id, service_id) values (1000009, 850);
insert into categories_services (category_id, service_id) values (1000009, 2880);

-- Job Placement subcategory
insert into categories_services (category_id, service_id) values (1100032, 2300);
insert into categories_services (category_id, service_id) values (1100032, 1070);
insert into categories_services (category_id, service_id) values (1100032, 624);
insert into categories_services (category_id, service_id) values (1100032, 194);
insert into categories_services (category_id, service_id) values (1100032, 2512);
insert into categories_services (category_id, service_id) values (1100032, 2503);
insert into categories_services (category_id, service_id) values (1100032, 486); 

-- Vocational Training Programs
insert into categories_services (category_id, service_id) values (1100033, 2881);
insert into categories_services (category_id, service_id) values (1100033, 2882);
insert into categories_services (category_id, service_id) values (1100033, 2676);
insert into categories_services (category_id, service_id) values (1100033, 1438);
insert into categories_services (category_id, service_id) values (1100033, 1648);
insert into categories_services (category_id, service_id) values (1100033, 850);

-- Job Boards
insert into categories_services (category_id, service_id) values (1100034, 2880);


-- Covid Finance Category and Subcategories
delete from category_relationships where parent_id=1000003 and child_id=1100010;
delete from categories_services where category_id=1000003 and service_id=1070;

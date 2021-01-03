-- "Rental Assistance and Eviction Prevention" Category
-- Already there
-- insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured)
-- values (1000004, '13-DEC-20', '13-DEC-20', 'Covid-housing', 'f', null, 'f');

-- "Rental Assistance and Eviction Prevention" Subcategories
insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured)
values (1_400_001, '13-DEC-20', '03-JAN-21', 'My landlord gave me an eviction notice and I need legal help', 'f', null, 'f');
insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured)
values (1_400_002, '13-DEC-20', '03-JAN-21', 'My landlord told me I would get evicted and I need advice', 'f', null, 'f');
insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured)
values (1_400_003, '13-DEC-20', '03-JAN-21', 'I have not been able to pay my rent and I do not know what to do', 'f', null, 'f');
insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured)
values (1_400_004, '13-DEC-20', '03-JAN-21', 'I am not getting along with my neighbor(s) and /or my landlord and I need advice', 'f', null, 'f');

-- Insert subcategories in "Rental Assistance and Eviction Prevention"
insert into category_relationships (parent_id, child_id)
values (1000004, 1_400_001);
insert into category_relationships (parent_id, child_id)
values (1000004, 1_400_002);
insert into category_relationships (parent_id, child_id)
values (1000004, 1_400_003);
insert into category_relationships (parent_id, child_id)
values (1000004, 1_400_004);

-- Insert services to "Rental Assistance and Eviction Prevention" categories
insert into categories_services (category_id, service_id)
values (1000004, 2216);

insert into categories_services (category_id, service_id)
values (1000004, 959);
insert into categories_services (category_id, service_id)
values (1000004, 2209);
insert into categories_services (category_id, service_id)
values (1000004, 1134);
insert into categories_services (category_id, service_id)
values (1000004, 1210);
insert into categories_services (category_id, service_id)
values (1000004, 2835);
insert into categories_services (category_id, service_id)
values (1000004, 2663);

insert into categories_services (category_id, service_id)
values (1000004, 2833);
insert into categories_services (category_id, service_id)
values (1000004, 2822);
insert into categories_services (category_id, service_id)
values (1000004, 1186);
insert into categories_services (category_id, service_id)
values (1000004, 1039);
insert into categories_services (category_id, service_id)
values (1000004, 2751);
insert into categories_services (category_id, service_id)
values (1000004, 2029);
insert into categories_services (category_id, service_id)
values (1000004, 2782);

insert into categories_services (category_id, service_id)
values (1000004, 1134);
-- repetitive
-- insert into categories_services (category_id, service_id)
-- values (1000004, 2209);
insert into categories_services (category_id, service_id)
values (1000004, 935);
-- insert into categories_services (category_id, service_id)
-- values (1000004, 1210);
insert into categories_services (category_id, service_id)
values (1000004, 1495);

-- Insert services to subcategories
insert into categories_services (category_id, service_id)
values (1_400_001, 2216);

insert into categories_services (category_id, service_id)
values (1_400_002, 959);
insert into categories_services (category_id, service_id)
values (1_400_002, 2209);
insert into categories_services (category_id, service_id)
values (1_400_002, 1134);
insert into categories_services (category_id, service_id)
values (1_400_002, 1210);
insert into categories_services (category_id, service_id)
values (1_400_002, 2835);
insert into categories_services (category_id, service_id)
values (1_400_002, 2663);

insert into categories_services (category_id, service_id)
values (1_400_003, 2833);
insert into categories_services (category_id, service_id)
values (1_400_003, 2822);
insert into categories_services (category_id, service_id)
values (1_400_003, 1186);
insert into categories_services (category_id, service_id)
values (1_400_003, 1039);
insert into categories_services (category_id, service_id)
values (1_400_003, 2751);
insert into categories_services (category_id, service_id)
values (1_400_003, 2029);
insert into categories_services (category_id, service_id)
values (1_400_003, 2782);

insert into categories_services (category_id, service_id)
values (1_400_004, 1134);
insert into categories_services (category_id, service_id)
values (1_400_004, 2209);
insert into categories_services (category_id, service_id)
values (1_400_004, 935);
insert into categories_services (category_id, service_id)
values (1_400_004, 1210);
insert into categories_services (category_id, service_id)
values (1_400_004, 1495);
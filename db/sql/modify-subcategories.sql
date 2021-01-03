-- "Rental Assistance and Eviction Prevention" Category
insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured)
values (1000004, '13-DEC-20', '13-DEC-20', 'Covid-housing', 'f', null, 'f');

-- "Rental Assistance and Eviction Prevention" Subcategories
insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured)
values (, '13-DEC-20', '13-DEC-20', 'My landlord gave me an eviction notice and I need legal help', 'f', null, 'f');
insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured)
values (, '13-DEC-20', '13-DEC-20', 'My landlord told me I would get evicted and I need advice', 'f', null, 'f');
insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured)
values (, '13-DEC-20', '13-DEC-20', 'I have not been able to pay my rent and I do not know what to do', 'f', null, 'f');
insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured)
values (, '13-DEC-20', '13-DEC-20', 'I am not getting along with my neighbor(s) and /or my landlord and I need advice', 'f', null, 'f');

-- Insert subcategories in "Rental Assistance and Eviction Prevention"
insert into category_relationships (parent_id, child_id)
values (1000004, );
insert into category_relationships (parent_id, child_id)
values (1000004, );
insert into category_relationships (parent_id, child_id)
values (1000004, );
insert into category_relationships (parent_id, child_id)
values (1000004, );

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
values (, 2216);

insert into categories_services (category_id, service_id)
values (, 959);
insert into categories_services (category_id, service_id)
values (, 2209);
insert into categories_services (category_id, service_id)
values (, 1134);
insert into categories_services (category_id, service_id)
values (, 1210);
insert into categories_services (category_id, service_id)
values (, 2835);
insert into categories_services (category_id, service_id)
values (, 2663);

insert into categories_services (category_id, service_id)
values (, 2833);
insert into categories_services (category_id, service_id)
values (, 2822);
insert into categories_services (category_id, service_id)
values (, 1186);
insert into categories_services (category_id, service_id)
values (, 1039);
insert into categories_services (category_id, service_id)
values (, 2751);
insert into categories_services (category_id, service_id)
values (, 2029);
insert into categories_services (category_id, service_id)
values (, 2782);

insert into categories_services (category_id, service_id)
values (, 1134);
insert into categories_services (category_id, service_id)
values (, 2209);
insert into categories_services (category_id, service_id)
values (, 935);
insert into categories_services (category_id, service_id)
values (, 1210);
insert into categories_services (category_id, service_id)
values (, 1495);
-- Internet Subcategories
insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured)
values (1400005, '13-JAN-21', '13-JAN-21', 'Computer and Internet Access', 'f', null, 'f');
insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured)
values (1400006, '13-JAN-21', '13-JAN-21', 'Computer Classes', 'f', null, 'f');
insert into categories (id, created_at, updated_at, name, top_level, vocabulary, featured)
values (1400007, '13-JAN-21', '13-JAN-21', 'Cell Phone Services', 'f', null, 'f');

insert into category_relationships (parent_id, child_id)
values (1000007, 1400001);
insert into category_relationships (parent_id, child_id)
values (1000007, 1400002);
insert into category_relationships (parent_id, child_id)
values (1000007, 1400003);

insert into categories_services (category_id, service_id)
values (1000007, 106);
insert into categories_services (category_id, service_id)
values (1000007, 3096);
insert into categories_services (category_id, service_id)
values (1000007, 2857);
insert into categories_services (category_id, service_id)
values (1000007, 106);
insert into categories_services (category_id, service_id)
values (1000007, 3092);
insert into categories_services (category_id, service_id)
values (1000007, 3095);


insert into categories_services (category_id, service_id)
values (1000005, 106);
insert into categories_services (category_id, service_id)
values (1000005, 3096);
insert into categories_services (category_id, service_id)
values (1000005, 2857);
insert into categories_services (category_id, service_id)
values (1000006, 106);
insert into categories_services (category_id, service_id)
values (1000006, 3092);
insert into categories_services (category_id, service_id)
values (1000007, 3095);


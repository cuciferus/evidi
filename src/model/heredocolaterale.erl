-module(heredocolaterale, [Id, Boala, RudaId, PacientId]). %oare nu ma intereseaza si la ce varsta a aparut boala?
-compile(export_all).
-belongs_to(pacient).
-belongs_to(ruda).

-- Time-stamp: <19 oct 2012 15:00 queinnec@enseeiht.fr>

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Exceptions;

-- Version avec machine à etats. Pas de priorité définie.
package body LR.Synchro.Basique is
   
   function Nom_Strategie return String is
   begin
      return "Basique, par machine à états";
   end Nom_Strategie;
   
   task LectRedTask is
      entry Demander_Lecture;
      entry Demander_Ecriture;
      entry Terminer_Lecture;
      entry Terminer_Ecriture;
   end LectRedTask;

   task body LectRedTask is
      nb_lecture : Integer := 0;
      nb_ecriture : Integer := 0;
   begin
      loop
         select
            when (nb_ecriture = 0) => accept Demander_Lecture;
               nb_lecture := nb_lecture + 1;
            or when (nb_lecture + nb_ecriture = 0) => accept Demander_Ecriture;
               nb_ecriture := nb_ecriture + 1;
            or accept Terminer_Lecture;
               nb_lecture := nb_lecture - 1;
            or accept Terminer_Ecriture;
               nb_ecriture := nb_ecriture - 1;
            or terminate;
         end select;
      end loop;
   exception
      when Error: others =>
         Put_Line("**** LectRedTask: exception: " & Ada.Exceptions.Exception_Information(Error));
   end LectRedTask;

   procedure Demander_Lecture is
   begin
      LectRedTask.Demander_Lecture;
   end Demander_Lecture;

   procedure Demander_Ecriture is
   begin
      LectRedTask.Demander_Ecriture;
   end Demander_Ecriture;

   procedure Terminer_Lecture is
   begin
      LectRedTask.Terminer_Lecture;
   end Terminer_Lecture;

   procedure Terminer_Ecriture is
   begin
      LectRedTask.Terminer_Ecriture;
   end Terminer_Ecriture;

end LR.Synchro.Basique;

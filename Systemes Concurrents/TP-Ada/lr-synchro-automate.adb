with Ada.Text_IO; use Ada.Text_IO;
with Ada.Exceptions;

package body LR.Synchro.Automate is
   
   function Nom_Strategie return String is
   begin
      return "automate";
   end Nom_Strategie;

   task LectRedTask is
      entry Demander_Lecture;
      entry Demander_Ecriture;
      entry Terminer_Lecture;
      entry Terminer_Ecriture;
   end LectRedTask;

   type Etats is (Libre, Lecteur, Ecrivain);

   task body LectRedTask is
      Etat : Etats := Libre;
      nb_lecture : Integer := 0;
   begin
      loop
         if (Etat = Lecteur) then
            Select 
            accept Demander_Lecture;
               nb_lecture := nb_lecture + 1;
            or accept Terminer_Lecture;
               nb_lecture := nb_lecture - 1;
               if (nb_lecture = 0) then 
                  Etat := Libre;
               end if;
            end select;
         elsif (Etat = Libre) then 
            Select 
            accept Demander_Lecture;
               nb_lecture := nb_lecture + 1;
               Etat := Lecteur;
            or accept Demander_Ecriture;
               Etat := Ecrivain;
            end select;
         else
            Select 
            accept Terminer_Ecriture;
               Etat := Libre;
            end select;
         end if;
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

end LR.Synchro.Automate;

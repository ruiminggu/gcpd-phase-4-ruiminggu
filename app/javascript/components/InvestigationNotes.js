import React, { useState } from 'react';
import FormattedDate from './FormattedDate'
import PropTypes from 'prop-types';
import { post } from '../api';

function NoteEditor({ onSave, onCancel }){
  const [noteText, setNoteText] = useState('');

  const handleSave = () => {
    if (noteText) {
      onSave(noteText);
      setNoteText('');
    }
  };
  
  return (
    <div className="note-form">
      <textarea
        value={noteText}
        onChange={(e) => setNoteText(e.target.value)}
        placeholder="Enter a new note ..."/>
        <button onClick={handleSave}>Save</button>
        <button onClick={onCancel}>Cancel</button>
    </div>
  );
}

NoteEditor.propTypes = {
  onSave: PropTypes.func.isRequired,
  onCancel: PropTypes.func.isRequired,
};


function InvestigationNotes({ notes, investigationId }){
  const [editorOpen, setEditorOpen] = React.useState(false);
  const [currentNotes, setCurrentNotes] = React.useState(notes);

  function handleSaveNote(content) {
    post(`/v1/investigations/${investigationId}/notes`, 
      { investigation_note: {content: content}, }).then((result) => {
      setEditorOpen(false);
      setCurrentNotes([result].concat(currentNotes));
    });
  }

  const content =
    currentNotes.length === 0 ? (
      <p>This investigation does not yet have notes associated with it.</p >
    ):(
      <>
      <ul>
        {currentNotes.map((note) => {
          const {officer, content, date} = note.data.attributes;
          const {first_name, last_name} = officer.data.attributes;
          return (
            <li key={`note-${note.data.id}`}>
              <p>
                {FormattedDate(date)}: {content}
                < br/>
                - {first_name} {last_name}
              </p >
            </li>
          );
        })}
      </ul>
      </>
    );
  return (
    <>
    <div class="card yellow lighten-5">
      <div class="card-content">
        <span class="card-title">Investigation Notes</span>
        {content}
        {editorOpen ? (
          <NoteEditor
            onCancel={() => setEditorOpen(false)}
            onSave={handleSaveNote}
            currentNotes={currentNotes}
          />
        ) : ( <button onClick={() => setEditorOpen(true)}>Add Note</button> )}
      </div>
    </div>
    </>
  );
}

InvestigationNotes.propTypes = {
  notes: PropTypes.arrayOf(PropTypes.object).isRequired,
  investigationId: PropTypes.string.isRequired,
};

export default InvestigationNotes;
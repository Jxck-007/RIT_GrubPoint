import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import ProfilePage from './components/ProfilePage';

function App() {
    return (
        <Router>
            <Switch>
                <Route path="/profile" component={ProfilePage} />
            </Switch>
        </Router>
    );
}

export default App;
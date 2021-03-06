/* Copyright (C) 2013, 2014 Artyom V. Poptsov <poptsov.artyom@gmail.com>
 *
 * This file is part of Guile-SSH.
 * 
 * Guile-SSH is free software: you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * Guile-SSH is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Guile-SSH.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef __AUTH_H__
#define __AUTH_H__

extern SCM guile_ssh_userauth_public_key_x (SCM arg1, SCM arg2);
extern SCM guile_ssh_userauth_public_key_auto_x (SCM arg1);
extern SCM guile_ssh_userauth_public_key_try (SCM arg1, SCM arg2);
extern SCM guile_ssh_userauth_agent_x (SCM arg1);
extern SCM guile_ssh_userauth_password_x (SCM arg1, SCM arg2);
extern SCM guile_ssh_userauth_none_x (SCM arg1);
extern SCM guile_ssh_userauth_get_list (SCM arg1);

extern void init_auth_func (void);

#endif /* ifndef __AUTH_H__ */

/* auth.h ends here */
